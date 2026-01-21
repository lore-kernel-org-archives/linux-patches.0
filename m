Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0385A3BB9E8;
	Wed, 21 Jan 2026 18:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020339; cv=none; b=rAjWzL1KbvoSBmm5n/kzzdnXeyrR+NXv+jLsXb8OBc8a3fbOl8mzkqglG6oEAG/OGWW772zwmjKAdfxhznkTabH7aoOx8cWLDGgglQ+SCd1SG6rLSxM977nfcCaF8Icqlsk1T6VOF44EqDHqEdw2qw+1yNWud+xlgBXYy9i4zRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020339; c=relaxed/simple;
	bh=IR5HQG0lpvpudbe9FO5CBNu6iOMO2+6tpvBCrWnZcrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAg60GpC+CkixglBxynwC7xCUqvKeZFvoZbkj3EcVrqiDUkDCif20ZzfcorAtu4iHQFRwUBOblHyyTpyTNTuzdUWqdLP1OWqqgdTXyB/8/XxlQhAJmY9Zp5P3MNV7l1OhKkZElt6h17kda9P7xZxWumwaUG75imFmXsZCFE8hAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNwPFVAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNwPFVAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB8DC4CEF1;
	Wed, 21 Jan 2026 18:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020338;
	bh=IR5HQG0lpvpudbe9FO5CBNu6iOMO2+6tpvBCrWnZcrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNwPFVAY6csl0jLteorThu5VSGK0TyE/S1YnSamFYT2u8kVOFg1cqKjj22blfjGlp
	 xScUmyGZ7HrmKWpDlmJo7xudNwY218LgqaoQ50sdMaHiqGdZTki66X0LBPjaCUtBod
	 oe6Sq6HETTGZNd/jDqhr7s/w1VBLSe5+UshISjnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 128/198] ext4: fix ext4_tune_sb_params padding
Date: Wed, 21 Jan 2026 19:15:56 +0100
Message-ID: <20260121181423.156021076@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit cd16edba1c6a24af138e1a5ded2711231fffa99f upstream.

The padding at the end of struct ext4_tune_sb_params is architecture
specific and in particular is different between x86-32 and x86-64,
since the __u64 member only enforces struct alignment on the latter.

This shows up as a new warning when test-building the headers with
-Wpadded:

include/linux/ext4.h:144:1: error: padding struct size to alignment boundary with 4 bytes [-Werror=padded]

All members inside the structure are naturally aligned, so the only
difference here is the amount of padding at the end. Make the padding
explicit, to have a consistent sizeof(struct ext4_tune_sb_params) of
232 on all architectures and avoid adding compat ioctl handling for
EXT4_IOC_GET_TUNE_SB_PARAM/EXT4_IOC_SET_TUNE_SB_PARAM.

This is an ABI break on x86-32 but hopefully this can go into 6.18.y early
enough as a fixup so no actual users will be affected.  Alternatively, the
kernel could handle the ioctl commands for both sizes (232 and 228 bytes)
on all architectures.

Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20251204101914.1037148-1-arnd@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/ext4.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/linux/ext4.h
+++ b/include/uapi/linux/ext4.h
@@ -139,7 +139,7 @@ struct ext4_tune_sb_params {
 	__u32 clear_feature_incompat_mask;
 	__u32 clear_feature_ro_compat_mask;
 	__u8  mount_opts[64];
-	__u8  pad[64];
+	__u8  pad[68];
 };
 
 #define EXT4_TUNE_FL_ERRORS_BEHAVIOR	0x00000001


