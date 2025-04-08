Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBA42641CC;
	Tue,  8 Apr 2025 11:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112929; cv=none; b=GVbkxEPjYHnngQWYMePTZWcS1LLL6rMoIvc+r7zIkBsCOGX7n6xgJ6uJ6ha2W/mJBbkjlDyqdaXQxGM+G9Y4BDqg2W79tDzThxJ4G5PCcmno396jmhGMT/Il7J4dW3c1JRqAjZEGrTggKsXDCQ7vc0wcKcuov1mHo4TcpTeiTsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112929; c=relaxed/simple;
	bh=QtF2gQleksfSfCBAIkkQYJ+envF16Fc5qHORn1cJd+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/ro2em59Ww2TpbIIsrlA7n/9sznIx/NC4eUAf8nK0c5pobIYIb9iJLqqx8mhC5WUNpkaV12H2wNs3HhKR0J6UA8IvuLewk5IH4zr3idylcQGQOXwkmkhMKogxKW3c3gqBDWJxma2z21/Bat9npUFd2TiXEGGbLRvNESQmIqKDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJeqOsci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJeqOsci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E1EC4CEE5;
	Tue,  8 Apr 2025 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112929;
	bh=QtF2gQleksfSfCBAIkkQYJ+envF16Fc5qHORn1cJd+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJeqOsciK0AmYWSwBoATqouMHp8BTy7Rzm9DhMWy50SV9FyBc8gRNTXTsGWIRTbzc
	 vLY5m3qNFE3Qk/S/L3Tw5eHXYJOTLLpRBlVKDb2WfwFQ4oxvVXIl0hjVLjv2Evr8zX
	 11UjgmWP78C6EiNtX/UkJLME7oE8G+ElouEXZStM=
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
Subject: [PATCH 5.15 211/279] objtool, media: dib8000: Prevent divide-by-zero in dib8000_set_dds()
Date: Tue,  8 Apr 2025 12:49:54 +0200
Message-ID: <20250408104832.041308102@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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



