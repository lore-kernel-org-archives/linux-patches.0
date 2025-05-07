Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB92828E5FB;
	Wed,  7 May 2025 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644727; cv=none; b=AHmT8OkylSnWRz8LsFXg3g4JZrF4cnOaJpvG/iq4YqeSe1v3uWYqg1SX6mji2WKziRo2APr1cw6CqkCDCxYPll08g2FQVNlsBtJAFPtl5yenV54/7rpyrED+C3kSHgp9T2NyLIClXjTW65DJEK9cO8+CGgHs76aO0maI5TuBuFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644727; c=relaxed/simple;
	bh=joyG/6ZbOOkXZNr/mRTYBFo7Ac4Ka4xrobT4p/Oo0ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXCSgN0NeRS/ACI2vsWsfEs4LijAjEQWCRcLZpS1NJjAzEIhuUmsZ928FgagcrBCF/aYqpqya7Y67XmuUplntAwXY95JWDd/m3mfMbAnzqWF5g1PhYld6lqIVmSNBPZcPCsPB2jzwtxJ/A867Q1fF13ziVrJyAoOxYsMKKmD59g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=liiFsiXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="liiFsiXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A3BC4CEEE;
	Wed,  7 May 2025 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644727;
	bh=joyG/6ZbOOkXZNr/mRTYBFo7Ac4Ka4xrobT4p/Oo0ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liiFsiXmt9g7aT8B7gVJHyGLIIJvg/AdsBgtLG7r/8lMiRnCJit6uBJfDRfMUTuWc
	 SbvjP0A/cFbtrovqFlknI56nlX42hbH/keXeJD6GQDY/DxP8x4+Qp12NZDgkJDvkYz
	 DiuBVn0ZiGJfDnR/LCWStf8CyEK6z1i1paTgXU5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Huang <mmpgouride@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.12 138/164] bcachefs: Remove incorrect __counted_by annotation
Date: Wed,  7 May 2025 20:40:23 +0200
Message-ID: <20250507183826.560526336@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


