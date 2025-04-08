Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB63268685;
	Tue,  8 Apr 2025 12:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114068; cv=none; b=fU5hfjdv01HaepiPM1qW4CHCixwsMdwGWQOLaS5LJTZVwwkOlwEHjMsjfOWw+G1H+YxlugVLwnbZXm6V8xQjqmft+0V7+rjK7ZVA500HRrGX4IAjIGFuGcu8gcyh4aiWCk2BNRQnuqOxG/3cgN4hii/G3bRLU8+Q9it6w1iwFDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114068; c=relaxed/simple;
	bh=Gobktv8SstNqrPiytHResXc7Cr4DqfyfTjA9OT/R70k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIYR73mJcYmdNIzFMfwDLxDLZN83OB0MjfXayI0hb+L/5T4NvDUCZzJKCgGEbjllHoYu6gwCVcpY5NQ1FjQITZ64gYxQMOF0bzdvC92AZXWfPJPDVd83RB/tKoAdPpEiEsJ0z7nSHrUzf/UR36I0+dKl/U1FGBdImiRghoVquBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKLvkBaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKLvkBaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA66C4CEE5;
	Tue,  8 Apr 2025 12:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114067;
	bh=Gobktv8SstNqrPiytHResXc7Cr4DqfyfTjA9OT/R70k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKLvkBaNnIa+dM36n8VZmSk47cf0lBYvpNNl7dHFRysxXmJFYGEpt2IDUU+zr6k/5
	 KznYHxrH7KOgi0ISxNwrNEoS5cAKcVkbnmO0IIjlLNRELUClE7LJg2hqsVz3+2jGXp
	 cUT448qJhWfmQ7hYMXUktI5zvplobL2kVU22CYG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/154] objtool, media: dib8000: Prevent divide-by-zero in dib8000_set_dds()
Date: Tue,  8 Apr 2025 12:51:06 +0200
Message-ID: <20250408104819.318676496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit e63d465f59011dede0a0f1d21718b59a64c3ff5c ]

If dib8000_set_dds()'s call to dib8000_read32() returns zero, the result
is a divide-by-zero.  Prevent that from happening.

Fixes the following warning with an UBSAN kernel:

  drivers/media/dvb-frontends/dib8000.o: warning: objtool: dib8000_tune() falls through to next function dib8096p_cfg_DibRx()

Fixes: 173a64cb3fcf ("[media] dib8000: enhancement")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/bd1d504d930ae3f073b1e071bcf62cae7708773c.1742852847.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/r/202503210602.fvH5DO1i-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib8000.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 02cb48223dc67..a28cbbd9e475c 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2701,8 +2701,11 @@ static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 	u8 ratio;
 
 	if (state->revision == 0x8090) {
+		u32 internal = dib8000_read32(state, 23) / 1000;
+
 		ratio = 4;
-		unit_khz_dds_val = (1<<26) / (dib8000_read32(state, 23) / 1000);
+
+		unit_khz_dds_val = (1<<26) / (internal ?: 1);
 		if (offset_khz < 0)
 			dds = (1 << 26) - (abs_offset_khz * unit_khz_dds_val);
 		else
-- 
2.39.5



