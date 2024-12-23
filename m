Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE961865EB;
	Mon, 23 Dec 2024 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970573; cv=none; b=YuJpMtoyOhfExPF6ikPOPYwrSwPlO1H+oDe1qFQikfVhssZM7DdSd2KHh5F7wvuVPYAV+SLVIUwLwfQFwFcIG8+N/8eWtEGOX3XNSzCw0DXSJ1okeFuBJHPH39f+pyVobIrd8mjFa75q7PvowMaZbG7qpZWK12IDsO/G8SDmWW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970573; c=relaxed/simple;
	bh=F7+yd9yDHBieiAhzdFPnCo7eNjUCPWfhLN8NnEfG3Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXtbrTbjm4+ZAGyahRFmk7vlzvOwdWlnEBb81GrzS+vTvk5CrKsupdoYtKLO1DnFiiMvWOx7px2PpuXpM4v69tHi4Hf4NVV2MsqGxWyN3jYZ6a1mbG9JhT268puh9m3SQ8NbDHrz3VKtTy8Dy9hAcGM4VKi9VKnx1eUgKbkQt2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxHCBWXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxHCBWXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9064FC4CED3;
	Mon, 23 Dec 2024 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970573;
	bh=F7+yd9yDHBieiAhzdFPnCo7eNjUCPWfhLN8NnEfG3Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxHCBWXMdwb2IpDf+vlpBCzwMjfFyZi+AroPggBaTwvOv3lg8t+Asou4bY8gRRQud
	 Pbv+rSL1Kql5IAy2qMELAKP07mrNYtvCC2zsxJSfonwiPtegmsz2MBITObOKQ8ttkb
	 493azHO/d9XOKsSQ8Ta5qig1BJ7OpoBBYlfYqdd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 6.6 104/116] udmabuf: also check for F_SEAL_FUTURE_WRITE
Date: Mon, 23 Dec 2024 16:59:34 +0100
Message-ID: <20241223155403.596256057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 0a16e24e34f28210f68195259456c73462518597 upstream.

When F_SEAL_FUTURE_WRITE was introduced, it was overlooked that udmabuf
must reject memfds with this flag, just like ones with F_SEAL_WRITE.
Fix it by adding F_SEAL_FUTURE_WRITE to SEALS_DENIED.

Fixes: ab3948f58ff8 ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd")
Cc: stable@vger.kernel.org
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204-udmabuf-fixes-v2-2-23887289de1c@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -194,7 +194,7 @@ static const struct dma_buf_ops udmabuf_
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)
-#define SEALS_DENIED (F_SEAL_WRITE)
+#define SEALS_DENIED (F_SEAL_WRITE|F_SEAL_FUTURE_WRITE)
 
 static long udmabuf_create(struct miscdevice *device,
 			   struct udmabuf_create_list *head,


