Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546EF214813;
	Wed,  7 May 2025 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643900; cv=none; b=NjRL+8mLHS6Dp+5SUfOKMUGgPvha51YIk4IrjGXOxPAzcCcDq3kB3BNmb5aBIKaiKOYNfK3Jf/4pGu0Etq8Z1crJV3P908rflag1TqNaW7X1+siO8yoF6Q10ivQVuv53212SW+ZxRmvmNw1X/kBnux4FxNPTC5nhuSigZC2J3f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643900; c=relaxed/simple;
	bh=/WvzxSC/autKE1PbIAnga3SW924c0KtTUkS9PX7vL9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK61AAPS4yV52v5wD3KlwrCU2LM35rv+C6VSTOuUFGDa6i8Qo7kCpQBDooxOyEuYSjbHQrv/cEhlnvRfeZm5FcYmIaJgYGYWjrFdBidQ/DfCc0S3YYWw92cPrmR6mJlj0EwLg7vxeZdQWNi5EDbPHajvWXgJqdR0f8YRXI+q2go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnTN7cbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnTN7cbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0CCC4AF0B;
	Wed,  7 May 2025 18:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643900;
	bh=/WvzxSC/autKE1PbIAnga3SW924c0KtTUkS9PX7vL9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnTN7cbR1yjmMN8F4VenZV4zQK6PQYfooxwTvy/rkLvHfzDc/X5cdfQMKhenDYk7O
	 1BFRwRa066bejb+dacChsb9TqAFkmy89fBIcA3Htw12zuc2bkU+TItYXjAs0U6AxDi
	 X9U1Oc8ECuAvmVUdqOGnr+4dM5HYWRsoDxGUGwdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.14 047/183] bcachefs: Remove incorrect __counted_by annotation
Date: Wed,  7 May 2025 20:38:12 +0200
Message-ID: <20250507183826.599950705@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Alan Huang <mmpgouride@gmail.com>

commit 6846100b00d97d3d6f05766ae86a0d821d849e78 upstream.

This actually reverts 86e92eeeb237 ("bcachefs: Annotate struct bch_xattr
with __counted_by()").

After the x_name, there is a value. According to the disscussion[1],
__counted_by assumes that the flexible array member contains exactly
the amount of elements that are specified. Now there are users came across
a false positive detection of an out of bounds write caused by
the __counted_by here[2], so revert that.

[1] https://lore.kernel.org/lkml/Zv8VDKWN1GzLRT-_@archlinux/T/#m0ce9541c5070146320efd4f928cc1ff8de69e9b2
[2] https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHUah8okKPReEt

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/xattr_format.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/bcachefs/xattr_format.h
+++ b/fs/bcachefs/xattr_format.h
@@ -13,7 +13,13 @@ struct bch_xattr {
 	__u8			x_type;
 	__u8			x_name_len;
 	__le16			x_val_len;
-	__u8			x_name[] __counted_by(x_name_len);
+	/*
+	 * x_name contains the name and value counted by
+	 * x_name_len + x_val_len. The introduction of
+	 * __counted_by(x_name_len) caused a false positive
+	 * detection of an out of bounds write.
+	 */
+	__u8			x_name[];
 } __packed __aligned(8);
 
 #endif /* _BCACHEFS_XATTR_FORMAT_H */


