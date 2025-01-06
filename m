Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43B91D934B;
	Mon,  6 Jan 2025 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179109; cv=none; b=jjGaM0hZmSmMzVMMmT8g4k0BelZhKutFXTEfw8KhsstrJVpAYYom+hKb2cITbCUw2G4fFdYj+mFm7MktJfIAW3/xatDunbYbs3+AMwGfxdLW5J6di7O/p6uPLCtNK+pIoKZiTgyaZdG4IadGXLSyBBk8JAZxU51M7MhTYAOJ/Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179109; c=relaxed/simple;
	bh=S2yLiKhT7kDC16UpTneHgDQtpjT+g7P8bGw7IBoA2rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsp3gSXO0tHv2tmXxI1t3ufn1cZgafDK4Ve/9zzllDb2enxJGJbWJ7k1/6DzkjVEkcAjtVA9ucsdBltE7wZSCwpACGHrZ9NSfCgoaVIbJFAIOBdzSacFatgFux2FxtM3Z2cRgqs9N29TufYelp7Pot+cGa4q6NxVewtv1DXeOqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvuya0cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvuya0cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC888C4CED2;
	Mon,  6 Jan 2025 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179108;
	bh=S2yLiKhT7kDC16UpTneHgDQtpjT+g7P8bGw7IBoA2rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvuya0cI08eU5tDvIFg4Ju2E7iOBYu5MsnUfsr6paVvUX18Ci7W/MsdvPFaiSFLMj
	 21JVQdSvffEGmo0ulDFX3eajXS8C9QB42IY/pMpxoeYr1/1ZGxgicBcJDPPiND/XHp
	 3n9hcUWb/skZoxwc/xm0QVr99zHxruylsdS4Jqbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.4 30/93] udmabuf: also check for F_SEAL_FUTURE_WRITE
Date: Mon,  6 Jan 2025 16:17:06 +0100
Message-ID: <20250106151129.842536507@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -120,7 +120,7 @@ static const struct dma_buf_ops udmabuf_
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)
-#define SEALS_DENIED (F_SEAL_WRITE)
+#define SEALS_DENIED (F_SEAL_WRITE|F_SEAL_FUTURE_WRITE)
 
 static long udmabuf_create(const struct udmabuf_create_list *head,
 			   const struct udmabuf_create_item *list)


