Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E0D1F1306;
	Wed, 30 Jul 2025 09:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868279; cv=none; b=InkglX+Jl1uZHuW4ZB/sEbq32hkURQZpqMYzPBS8P10Hfd7HRkWS0JEld9EZgs1vUESE0gQL6Nws9RvRZoKtnxLoxy4D7tWTwlpIXJNkEMLXFggCo7sHZwZ47OeUSPh4UQOKQyhXmSMRBplOLvdRxQ58vUWjN0Nrze/iUQVpfQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868279; c=relaxed/simple;
	bh=b/SlJ/kVFqfFd7ppPFmnUkCtnvn/a+GsHh9EAS5Av2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2s6XoHnDyLT9pDweEtyyM7OYG5o3jt83dzscbgLp+0ypc9OQt10CzZiuFWzKoSAXxw8yrhkf4EJff+hk+Yz4PGuvRm4b6RV3uhw2FiP0EqkHxZS1sH+ub3LeaHor/RgctZ8UA4wLGgDSYfri/zNaITFR9/nv1E9fIaZACJMkcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjLdt4IE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjLdt4IE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAB2C4CEE7;
	Wed, 30 Jul 2025 09:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868279;
	bh=b/SlJ/kVFqfFd7ppPFmnUkCtnvn/a+GsHh9EAS5Av2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjLdt4IEhkbHjPyOCLC0H8sbibs362joQEiDS6REnJYS+EbuNnhQDDpfebnrhhelj
	 KDgDnwn0cOlAoGl0KyAvbz+V3fecRXUED+2xexwBeh5fuKGyYvFQFeUkSiRHmnxhdr
	 Dr+9ExhjlgthR8kZsmuo9hYimHKN4zNK5+IHojxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aliaksei Makarau <Aliaksei.Makarau@ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/76] s390/ism: fix concurrency management in ism_cmd()
Date: Wed, 30 Jul 2025 11:35:16 +0200
Message-ID: <20250730093227.742807414@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit 897e8601b9cff1d054cdd53047f568b0e1995726 ]

The s390x ISM device data sheet clearly states that only one
request-response sequence is allowable per ISM function at any point in
time.  Unfortunately as of today the s390/ism driver in Linux does not
honor that requirement. This patch aims to rectify that.

This problem was discovered based on Aliaksei's bug report which states
that for certain workloads the ISM functions end up entering error state
(with PEC 2 as seen from the logs) after a while and as a consequence
connections handled by the respective function break, and for future
connection requests the ISM device is not considered -- given it is in a
dysfunctional state. During further debugging PEC 3A was observed as
well.

A kernel message like
[ 1211.244319] zpci: 061a:00:00.0: Event 0x2 reports an error for PCI function 0x61a
is a reliable indicator of the stated function entering error state
with PEC 2. Let me also point out that a kernel message like
[ 1211.244325] zpci: 061a:00:00.0: The ism driver bound to the device does not support error recovery
is a reliable indicator that the ISM function won't be auto-recovered
because the ISM driver currently lacks support for it.

On a technical level, without this synchronization, commands (inputs to
the FW) may be partially or fully overwritten (corrupted) by another CPU
trying to issue commands on the same function. There is hard evidence that
this can lead to DMB token values being used as DMB IOVAs, leading to
PEC 2 PCI events indicating invalid DMA. But this is only one of the
failure modes imaginable. In theory even completely losing one command
and executing another one twice and then trying to interpret the outputs
as if the command we intended to execute was actually executed and not
the other one is also possible.  Frankly, I don't feel confident about
providing an exhaustive list of possible consequences.

Fixes: 684b89bc39ce ("s390/ism: add device driver for internal shared memory")
Reported-by: Aliaksei Makarau <Aliaksei.Makarau@ibm.com>
Tested-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Tested-by: Aliaksei Makarau <Aliaksei.Makarau@ibm.com>
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250722161817.1298473-1-wintera@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 3 +++
 include/linux/ism.h        | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index af0d90beba638..76ba36c83e522 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -130,6 +130,7 @@ static int ism_cmd(struct ism_dev *ism, void *cmd)
 	struct ism_req_hdr *req = cmd;
 	struct ism_resp_hdr *resp = cmd;
 
+	spin_lock(&ism->cmd_lock);
 	__ism_write_cmd(ism, req + 1, sizeof(*req), req->len - sizeof(*req));
 	__ism_write_cmd(ism, req, 0, sizeof(*req));
 
@@ -143,6 +144,7 @@ static int ism_cmd(struct ism_dev *ism, void *cmd)
 	}
 	__ism_read_cmd(ism, resp + 1, sizeof(*resp), resp->len - sizeof(*resp));
 out:
+	spin_unlock(&ism->cmd_lock);
 	return resp->ret;
 }
 
@@ -630,6 +632,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	spin_lock_init(&ism->lock);
+	spin_lock_init(&ism->cmd_lock);
 	dev_set_drvdata(&pdev->dev, ism);
 	ism->pdev = pdev;
 	ism->dev.parent = &pdev->dev;
diff --git a/include/linux/ism.h b/include/linux/ism.h
index 9a4c204df3da1..04e2fc1973ce4 100644
--- a/include/linux/ism.h
+++ b/include/linux/ism.h
@@ -28,6 +28,7 @@ struct ism_dmb {
 
 struct ism_dev {
 	spinlock_t lock; /* protects the ism device */
+	spinlock_t cmd_lock; /* serializes cmds */
 	struct list_head list;
 	struct pci_dev *pdev;
 
-- 
2.39.5



