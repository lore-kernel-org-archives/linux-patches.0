Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFF4282F5;
	Mon,  6 Jan 2025 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178661; cv=none; b=QMyI5UkARu5T6eEcqHXO9ewwtLIn/YE17G4cn9qGQ26zpBULIcdKKomGwjG/yoTU2V+9STAq2X6s70F2f5xxVqUl7BcSSbHr/8DfbxS+IMy5fugGCvpyJd6oBys1L3/Rv5DYhiwrdIjNFwlmJPleIahKh4V+AZjmPbWWsGlUEFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178661; c=relaxed/simple;
	bh=AW/7lMntPaw37VTFLysfmJQlaNdTcGnEJhvZ0+Fw49A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXVUHVK/1nCTBwdgs1dIJzYVT8H64HTx5bXfKjeKVUREQ1TEOaTsFPb610a+2w8doTR9WefJimnJwSxFZcRcCPXZJ/nZ+kbCntzvROJwkOD9izfGV8zXUbnBGutGeY12KyGX7NY3k4ONiHKPEI+rww5A7xpTPrXFyCqWpq1ARFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAN0vaj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAN0vaj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20A2C4CEDF;
	Mon,  6 Jan 2025 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178661;
	bh=AW/7lMntPaw37VTFLysfmJQlaNdTcGnEJhvZ0+Fw49A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAN0vaj53IKSA/cCDnbdr/86JGgEek1WfJq+AEP7qGJgfnnRlUlNaiK+3ID1LvFJS
	 pwPNJlhhSOBzSP+G5AknpqcwfNpGbtU4jR+1ZCu68ZqeADJn856rAkrHGJ7Jgx9VFx
	 XAuTNNI6RSRbA9Dw7ky54k2n1gPORz0tmhNooQZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.15 051/168] udmabuf: also check for F_SEAL_FUTURE_WRITE
Date: Mon,  6 Jan 2025 16:15:59 +0100
Message-ID: <20250106151140.390632986@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -164,7 +164,7 @@ static const struct dma_buf_ops udmabuf_
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)
-#define SEALS_DENIED (F_SEAL_WRITE)
+#define SEALS_DENIED (F_SEAL_WRITE|F_SEAL_FUTURE_WRITE)
 
 static long udmabuf_create(struct miscdevice *device,
 			   struct udmabuf_create_list *head,


