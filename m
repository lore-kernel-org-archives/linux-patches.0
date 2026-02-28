Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05603321D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301192; cv=none; b=OI04jXnyUOS05jfQsbO/KU3ahnxRC93L9c4AEiXYbGZU3SmvBd+2ZAQqng1DtiFnWVNrzwYBtIzrr/Rt2bpZH2ucMGTdHjHisP4MdTwq0S4oaCLUAi//blt0Vnhv49Ctg1vaDDAWcA9EomauYfH5XrTlQDlkeR6mzAoLw0QyCzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301192; c=relaxed/simple;
	bh=lhno9CxasPaA40deyQx87nJXvzL976agX6vpuFQs7+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1EkXGz/kusveFMd11TYSmEc+aIw279dtzR2KLIx92xl5J6vmMW1irLCx/Hn1dMuBK4tJDZUKq3cnODAddF0xKxnCHxPrgD5zqG2zFi71KfDwED/S44vFRNnPfbfDqUO7TBu94cecg/1rA1LPb/rSaRdsTVetU166rf7woBdz3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s8gt3kWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s8gt3kWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D59C19423;
	Sat, 28 Feb 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301192;
	bh=lhno9CxasPaA40deyQx87nJXvzL976agX6vpuFQs7+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8gt3kWFNJh9H3lewqNljL8qBP8buQHmWF2jFb0Fzyj/Es+ZidRGHOuCadPQP5UU/
	 Za/+3PBj7mRJNWxz2l6aGPHF5Apxlo1S4Vyqm+4LvV0J9PIUsEt3108IcuTCP4puzx
	 ckVsMUDtkGl1SaUFgFF7A0Fx1GN8LTOuEr0hptFkFZbqmIGjEOx7gexErA1AjBSPHy
	 Hfmwm4czAPQZk4DhWHY/DWYPbhnfQmefAPXcsqMtixq9SBjZK5EK8DYp5v2EKmcUKJ
	 B5uwpD2oCe9bCCVg7V/ekfIJk3OtekGcM7kf5vkARSD/MNV/FAywUXO+S9YxYdWZ7p
	 w+/1iEtfb0z2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/752] fs/ntfs3: avoid calling run_get_entry() when run == NULL in ntfs_read_run_nb_ra()
Date: Sat, 28 Feb 2026 12:41:14 -0500
Message-ID: <20260228174750.1542406-363-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit c5226b96c08a010ebef5fdf4c90572bcd89e4299 ]

When ntfs_read_run_nb_ra() is invoked with run == NULL the code later
assumes run is valid and may call run_get_entry(NULL, ...), and also
uses clen/idx without initializing them. Smatch reported uninitialized
variable warnings and this can lead to undefined behaviour. This patch
fixes it.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512230646.v5hrYXL0-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index ef0177b5c6cb0..83df92df1ee0c 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1252,6 +1252,12 @@ int ntfs_read_run_nb(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 
 		} while (len32);
 
+		if (!run) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		/* Get next fragment to read. */
 		vcn_next = vcn + clen;
 		if (!run_get_entry(run, ++idx, &vcn, &lcn, &clen) ||
 		    vcn != vcn_next) {
-- 
2.51.0

