Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0241C9B99;
	Tue,  8 Oct 2024 13:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392819; cv=none; b=ocVnG0Z16y7Za08mOjOlkhr1d6KHYCsCIR0H0Qq5apzE0AZiV9xXOfUes4R/hdSODuWiNlmZGgi3kGvCkWAf+U3sja4jNdO9sUfy876Tj9Kv/9bWh2p+XylcnTsUSeKd3KgIycaNRQLsW0w4vJ2IBdBf5BzGtFJx0G3Q6mvgYWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392819; c=relaxed/simple;
	bh=GCpW5olJI1JC1dNqcKGdYxcFx9ZdsOaxjtyORMUxjDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8Bz+BoJs+YqmRC2eYplZ3bTN7SyLAwSyLWceBEDxkGix+jMeCsk+pBnJb57Kdoec34sRdsCe6ARk1yGdB0xWP2twRXF6kmdOv0+GBsZcueKosjRgVZhSkqGX7bvv/oTuFH7XQMCkX2EyuogLSfXiKHQh8280d5eotAJDeuYct0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrBviQOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrBviQOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A73C4CECC;
	Tue,  8 Oct 2024 13:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392819;
	bh=GCpW5olJI1JC1dNqcKGdYxcFx9ZdsOaxjtyORMUxjDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrBviQOdSVBWgFhUFP3Qe7K6ON1rYNhhD9jBt1gADB6lXqYHJn7Olk6eGpgZayDuj
	 jZdvyFH6Udqa9q5JU+XQGUhtpWdp5eAuMn5hh8U4TNKt2QPn/BRiVghn1WHGtfmVpl
	 jyrZdfU0XVz/jAE0UB3FQ70yo+dcJUl4EWV+s3X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Bonelli <marco@mebeim.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 529/558] kconfig: fix infinite loop in sym_calc_choice()
Date: Tue,  8 Oct 2024 14:09:19 +0200
Message-ID: <20241008115723.043714061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4d46b5b623e0adee1153b1d80689211e5094ae44 ]

Since commit f79dc03fe68c ("kconfig: refactor choice value calculation"),
Kconfig for ARCH=powerpc may result in an infinite loop. This occurs
because there are two entries for POWERPC64_CPU in a choice block.

If the same symbol appears twice in a choice block, the ->choice_link
node is added twice to ->choice_members, resulting a corrupted linked
list.

A simple test case is:

    choice
            prompt "choice"

    config A
            bool "A"

    config B
            bool "B 1"

    config B
            bool "B 2"

    endchoice

Running 'make defconfig' results in an infinite loop.

One solution is to replace the current two entries:

    config POWERPC64_CPU
            bool "Generic (POWER5 and PowerPC 970 and above)"
            depends on PPC_BOOK3S_64 && !CPU_LITTLE_ENDIAN
            select PPC_64S_HASH_MMU

    config POWERPC64_CPU
            bool "Generic (POWER8 and above)"
            depends on PPC_BOOK3S_64 && CPU_LITTLE_ENDIAN
            select ARCH_HAS_FAST_MULTIPLIER
            select PPC_64S_HASH_MMU
            select PPC_HAS_LBARX_LHARX

with the following single entry:

    config POWERPC64_CPU
            bool "Generic 64 bit powerpc"
            depends on PPC_BOOK3S_64
            select ARCH_HAS_FAST_MULTIPLIER if CPU_LITTLE_ENDIAN
            select PPC_64S_HASH_MMU
            select PPC_HAS_LBARX_LHARX if CPU_LITTLE_ENDIAN

In my opinion, the latter looks cleaner, but PowerPC maintainers may
prefer to display different prompts depending on CPU_LITTLE_ENDIAN.

For now, this commit fixes the issue in Kconfig, restoring the original
behavior. I will reconsider whether such a use case is worth supporting.

Fixes: f79dc03fe68c ("kconfig: refactor choice value calculation")
Reported-by: Marco Bonelli <marco@mebeim.net>
Closes: https://lore.kernel.org/all/1763151587.3581913.1727224126288@privateemail.com/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/parser.y | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
index 61900feb4254a..add1ce4b5091d 100644
--- a/scripts/kconfig/parser.y
+++ b/scripts/kconfig/parser.y
@@ -158,8 +158,14 @@ config_stmt: config_entry_start config_option_list
 			yynerrs++;
 		}
 
-		list_add_tail(&current_entry->sym->choice_link,
-			      &current_choice->choice_members);
+		/*
+		 * If the same symbol appears twice in a choice block, the list
+		 * node would be added twice, leading to a broken linked list.
+		 * list_empty() ensures that this symbol has not yet added.
+		 */
+		if (list_empty(&current_entry->sym->choice_link))
+			list_add_tail(&current_entry->sym->choice_link,
+				      &current_choice->choice_members);
 	}
 
 	printd(DEBUG_PARSE, "%s:%d:endconfig\n", cur_filename, cur_lineno);
-- 
2.43.0



