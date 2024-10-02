Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D0E1D07A3;
	Wed,  2 Oct 2024 13:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876507; cv=none; b=sJoM1DozajEr6CjIPPoZ+PiCOt0zKtTGkFygP9VD2WXZNDQ/Cs+q86Bg8WicQXG2ZTjEnAVsGLH56sfnsJ1TJeQ9xB6vG2vTJXGz2cdzGTZctslHtAHN8S+G/d6cf6fQQ6dBpRLiNh1fMAtpkVhGzOD7rVmCIgKhHrsVx9EPLLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876507; c=relaxed/simple;
	bh=v8N1v1P9Jq2MN/GqKO4gzW9BvccMfwau4l9NWLH/f8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzV6f5FUeL4mwvAxIR5Cl8ebyXCF+aARx9pDL3nSFQujfY7MRzNvgvG1X0GcmK4qcPLLds7yEJ7tjgsgLisyt8YJJJ0814BtMrDM8sGilsmgqD2jfZMloybivcqB9/gznYlVBT3UmBbRQjcic4RI864GUZ5esMRc6GLt0ro4RC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK9upcOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK9upcOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE18C4CEC5;
	Wed,  2 Oct 2024 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876506;
	bh=v8N1v1P9Jq2MN/GqKO4gzW9BvccMfwau4l9NWLH/f8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK9upcOXso/HyV4x4pi+aBRswMKe+AkDs+rgfmDBP2a5wO1VAVFh6jFJ/ybfQBNYn
	 sDXfqXb3oMRQkoFY5f/ub3OwKVTpnX2iU2/QFe2quofto282/ajCfKK3oiewHCEFPz
	 n7jawjy0zX/eE8gy1DS75Spp3bHwQX3GXm6z7mFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 468/695] dm integrity: fix gcc 5 warning
Date: Wed,  2 Oct 2024 14:57:46 +0200
Message-ID: <20241002125841.144360373@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit a8fa6483b40943a6c8feea803a2dc8e9982cc766 ]

This commit fixes gcc 5 warning "logical not is only applied to the left
hand side of comparison"

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index acff2f64f251f..4545d934f73d3 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4717,13 +4717,18 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		ti->error = "Block size doesn't match the information in superblock";
 		goto bad;
 	}
-	if (!le32_to_cpu(ic->sb->journal_sections) != (ic->mode == 'I')) {
-		r = -EINVAL;
-		if (ic->mode != 'I')
+	if (ic->mode != 'I') {
+		if (!le32_to_cpu(ic->sb->journal_sections)) {
+			r = -EINVAL;
 			ti->error = "Corrupted superblock, journal_sections is 0";
-		else
+			goto bad;
+		}
+	} else {
+		if (le32_to_cpu(ic->sb->journal_sections)) {
+			r = -EINVAL;
 			ti->error = "Corrupted superblock, journal_sections is not 0";
-		goto bad;
+			goto bad;
+		}
 	}
 	/* make sure that ti->max_io_len doesn't overflow */
 	if (!ic->meta_dev) {
-- 
2.43.0



