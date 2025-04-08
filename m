Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A215E207E14;
	Tue,  8 Apr 2025 11:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112186; cv=none; b=gKJieGIl6Ul3Oc/WIv+0qidBErEmmZepmmpwvkivCeTGy30qqIGHETbEj2newPb1RMUB6M7UUvb78BYFugG92+i8bHOIpiwH14qYjwXccvDpLMQ/8nFuPafL8/bJbtjyH5fWWo2WJvECr8KKM3nmGZiDuEkQOCCBku2k+E8/PS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112186; c=relaxed/simple;
	bh=CCxQy7C3vnPly9f2nDeYip+XTvIJuDrTgCYR+CJ+ocY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMyHCmTukAt2nxV5qi1NGxS9tADaS8Xurv99TdDVFtIuahG5JwL0JrHY/cln+9eFVif8y3FfYan8NqUqKdMjnCGrEAAqfJCljVFeVcf4fvhHuVnq26CyPQMtkq19CL1308wc0e15JuQWwSCVGStdGECla45WEc2Z6ohhXwdplAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egwO1pHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egwO1pHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB40C4CEE5;
	Tue,  8 Apr 2025 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112186;
	bh=CCxQy7C3vnPly9f2nDeYip+XTvIJuDrTgCYR+CJ+ocY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egwO1pHpiy9evThYHBAdnqfFDOlDb5T7EIhUJVeLAROheLIRlfqZpQpITsTEbjgF8
	 U7KtDRQEyREfApIk4pJBUaD7nMfR7zvIsAvTdqpTplatOuPTg+q49bCEjiXIDLltTe
	 nGcp1yL6tgYfO9jzcWnlEhgZz9pZej2lvoeK9miQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.14 706/731] exfat: fix potential wrong error return from get_block
Date: Tue,  8 Apr 2025 12:50:03 +0200
Message-ID: <20250408104930.692799524@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungjong Seo <sj1557.seo@samsung.com>

commit 59c30e31425833385e6644ad33151420e37eabe1 upstream.

If there is no error, get_block() should return 0. However, when bh_read()
returns 1, get_block() also returns 1 in the same manner.

Let's set err to 0, if there is no error from bh_read()

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Cc: stable@vger.kernel.org
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -391,6 +391,8 @@ static int exfat_get_block(struct inode
 			/* Zero unwritten part of a block */
 			memset(bh_result->b_data + size, 0,
 			       bh_result->b_size - size);
+
+			err = 0;
 		} else {
 			/*
 			 * The range has not been written, clear the mapped flag


