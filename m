Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2C61BFDFC;
	Mon, 14 Oct 2024 15:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919209; cv=none; b=nXeX3ePxc2n0nCmoWuKXg/1zqbzksoWtmXiDW1c5Hb2frD4h/Hj4kgOQyAd/lgGTi0aqfQg2ObfzgxJbw0Ifxo+ktl58gMhWvsHmURExraY3pkKPMtm14FWE79bJvXmVTdqy/Q1Nl4YvMjg0YpEG7jeZ0C5mkd7m/ynzFtjFdTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919209; c=relaxed/simple;
	bh=b17S7zhLVxEvO/YObLPGRZyadH+r/I6aPb5c9eIpd/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfeSIzTGFDcHc9qh1uQ+lsgp5OHtGb2voN9ZweBimKf1DUl8A1a+PXUencDyPpoalM38vdFeHN2cTBnviG+cV7v9iOPHv8H+O5Ns3T4lNsRRUaIHVDRhjRFv+XHn/kWqVZbD6HJHQQ5DIXLOEr1OTYLpXOzI1Ir7NxIT6Z3fLrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2OZFJW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2OZFJW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9DBC4CEC3;
	Mon, 14 Oct 2024 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919209;
	bh=b17S7zhLVxEvO/YObLPGRZyadH+r/I6aPb5c9eIpd/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2OZFJW6ar/fdA+/mSgvDwOm3NDT0prwnd9eYALPcm505ATYxm2bPjbOZTnKNiZQf
	 jGf6dDv9V388VhkiHjeSBMLbMmQr2eB7vC9kdW/SwScvfenOE4CMXgDhOBitO9mBt2
	 0WaZY3kh58G1lEk39shAEqjlt6mNtgrENLQ+R7fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 544/798] ext4: propagate errors from ext4_find_extent() in ext4_insert_range()
Date: Mon, 14 Oct 2024 16:18:18 +0200
Message-ID: <20241014141239.370880377@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 369c944ed1d7c3fb7b35f24e4735761153afe7b3 upstream.

Even though ext4_find_extent() returns an error, ext4_insert_range() still
returns 0. This may confuse the user as to why fallocate returns success,
but the contents of the file are not as expected. So propagate the error
returned by ext4_find_extent() to avoid inconsistencies.

Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-11-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5570,6 +5570,7 @@ static int ext4_insert_range(struct file
 	path = ext4_find_extent(inode, offset_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		up_write(&EXT4_I(inode)->i_data_sem);
+		ret = PTR_ERR(path);
 		goto out_stop;
 	}
 


