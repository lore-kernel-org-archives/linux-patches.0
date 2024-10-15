Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2069D1E6321;
	Tue, 15 Oct 2024 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997689; cv=none; b=TAXiXsiirtptm8ISzaTV+vfx6FP6HFeYTUG100TyZDt215Q87t+gKs9EOPHOEUZYcUxMxoOBe2xEBG673XJWhYZ1Ro+w7IeKCsJpeA0AqGEaJKI0KI/1Ts7gFU3PZOLH4spE++8i06xnzk4NVuJ4Taw/0hOyTeLgY+c3qrQWYMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997689; c=relaxed/simple;
	bh=M3gnujApRWQUrJva+dXOp4CXnns76fDtYSqwelL7qZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vh8CM3xNDLRKi078AoxHrqOoUL80kbW0L6iay19QgweUaQHDrNFnKFmaXnrHP0rGB6XBz3FIdMVMQYMta3JrmVVYAcXrgQqbod0BWg4JGcW2xZk/Ew5QKBPz034+ui+7Dc8YRfma2kU3i4KDREerlU6VQHvVmnFbaSFnGPWnZzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jmnyt65P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmnyt65P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859B0C4CED1;
	Tue, 15 Oct 2024 13:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997689;
	bh=M3gnujApRWQUrJva+dXOp4CXnns76fDtYSqwelL7qZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmnyt65P0Df1q4+4slKVBg222ZOIax+sK6ZtFgJM8gNTlP8NU+8otJzHRxRoPsHic
	 GWBPFfiJcIrGS7JaqXBPWpsbHJSyQCPQRC4Szz/9ljOr+4Xj21WctGloGM8UIaBrCp
	 h5s5CFGQClOfLHSU/+2EX6rqCJdd0dF7cbooMR0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/518] pps: add an error check in parport_attach
Date: Tue, 15 Oct 2024 14:42:40 +0200
Message-ID: <20241015123926.870059457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 62c5a01a5711c8e4be8ae7b6f0db663094615d48 ]

In parport_attach, the return value of ida_alloc is unchecked, witch leads
to the use of an invalid index value.

To address this issue, index should be checked. When the index value is
abnormal, the device should be freed.

Found by code review, compile tested only.

Cc: stable@vger.kernel.org
Fixes: fb56d97df70e ("pps: client: use new parport device model")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/20240828131814.3034338-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps_parport.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index 4bb3678c7e451..84e49204912f8 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -145,6 +145,9 @@ static void parport_attach(struct parport *port)
 	}
 
 	index = ida_alloc(&pps_client_index, GFP_KERNEL);
+	if (index < 0)
+		goto err_free_device;
+
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -155,7 +158,7 @@ static void parport_attach(struct parport *port)
 						    index);
 	if (!device->pardev) {
 		pr_err("couldn't register with %s\n", port->name);
-		goto err_free;
+		goto err_free_ida;
 	}
 
 	if (parport_claim_or_block(device->pardev) < 0) {
@@ -183,8 +186,9 @@ static void parport_attach(struct parport *port)
 	parport_release(device->pardev);
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
-err_free:
+err_free_ida:
 	ida_free(&pps_client_index, index);
+err_free_device:
 	kfree(device);
 }
 
-- 
2.43.0



