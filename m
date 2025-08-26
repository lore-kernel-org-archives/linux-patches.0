Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042B634166B;
	Tue, 26 Aug 2025 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217546; cv=none; b=SqjbQF93xZSy7U6OBgQOjEq/W5zWBD87D+guBdzPRrTMz9ZV3w7un//ftvzkAOyT342xykcEVvS4xfCjpYYjhEx6kP1vnZn3Q/0yZJXPKbePhDrY1oju3k8Ea5CNurg/oPIKXMqSRzz9l44FpeHfiw2p7u6Yy+OVB6n9zlzzatQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217546; c=relaxed/simple;
	bh=NGKXUmWAsqDN691CrXuUy3zmeOs5E7HG6/Q5llgm3M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1gYNLNAIsTUx/6bINYm3teEy70SiKisGdWZGkBRUFe+7FeulGGJ2MGnlIcNFVDBIlwr/M6HUWHGdEkUqrPuOW1K3mzxaKc3Brzo5UA72nSK8cbvlBNnVXsOGjZ+J4nJmLPskQch06ZiR64yYLuvXj2ZGDKTpDZTq9yDQEhvp8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJYgog2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJYgog2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F91AC113D0;
	Tue, 26 Aug 2025 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217545;
	bh=NGKXUmWAsqDN691CrXuUy3zmeOs5E7HG6/Q5llgm3M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJYgog2F9igHClLRGMMxw26rVq7WP180pZuNvYNhHmNatakY1E5btx1Lft7Qt3isL
	 pRUBs0neeCWPZY/KnZqDesTCc1pmI3uGFMk5F5vfDwVMYDlpQr7x/IhLnBYo59o5BV
	 wRUU0xcDl5byNajraTu88JbiuHyijI+2m6qab3nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.10 184/523] perf/core: Exit early on perf_mmap() fail
Date: Tue, 26 Aug 2025 13:06:34 +0200
Message-ID: <20250826110928.992789415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 07091aade394f690e7b655578140ef84d0e8d7b0 upstream.

When perf_mmap() fails to allocate a buffer, it still invokes the
event_mapped() callback of the related event. On X86 this might increase
the perf_rdpmc_allowed reference counter. But nothing undoes this as
perf_mmap_close() is never called in this case, which causes another
reference count leak.

Return early on failure to prevent that.

Fixes: 1e0fb9ec679c ("perf/core: Add pmu callbacks to track event mapping and unmapping")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6413,6 +6413,9 @@ aux_unlock:
 		mutex_unlock(aux_mutex);
 	mutex_unlock(&event->mmap_mutex);
 
+	if (ret)
+		return ret;
+
 	/*
 	 * Since pinned accounting is per vm we cannot allow fork() to copy our
 	 * vma.


