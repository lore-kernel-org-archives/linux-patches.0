Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FE3524C2;
	Thu, 30 Nov 2023 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkMjekU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95993C433CA;
	Thu, 30 Nov 2023 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361590;
	bh=vqEbHMjsuL3oPbU/8iUjEWJWz/dxURkF0hc/7c6CM7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkMjekU2L5yi7R/tYbS7MBkgscAYTl8H4qpBNtsFVlblcB8nbGsV8yJE15AL06HRm
	 vNdwLeLJKJY7O5eN7VLbX3Staxz58/NRbUnVZRyMdGVpDYstmgPDWl+UQzols5kSV3
	 tzzMXZUBhps1CIzm+17bsf5joR9kSyC5ZGvZdj24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sam James <sam@gentoo.org>,
	Sasha Levin <sashal@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 058/112] prctl: Disable prctl(PR_SET_MDWE) on parisc
Date: Thu, 30 Nov 2023 16:21:45 +0000
Message-ID: <20231130162142.169133531@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 793838138c157d4c49f4fb744b170747e3dabf58 ]

systemd-254 tries to use prctl(PR_SET_MDWE) for it's MemoryDenyWriteExecute
functionality, but fails on parisc which still needs executable stacks in
certain combinations of gcc/glibc/kernel.

Disable prctl(PR_SET_MDWE) by returning -EINVAL for now on parisc, until
userspace has catched up.

Signed-off-by: Helge Deller <deller@gmx.de>
Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Sam James <sam@gentoo.org>
Closes: https://github.com/systemd/systemd/issues/29775
Tested-by: Sam James <sam@gentoo.org>
Link: https://lore.kernel.org/all/875y2jro9a.fsf@gentoo.org/
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index 4a8073c1b2558..7a4ae6d5aecd5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2395,6 +2395,10 @@ static inline int prctl_set_mdwe(unsigned long bits, unsigned long arg3,
 	if (bits & PR_MDWE_NO_INHERIT && !(bits & PR_MDWE_REFUSE_EXEC_GAIN))
 		return -EINVAL;
 
+	/* PARISC cannot allow mdwe as it needs writable stacks */
+	if (IS_ENABLED(CONFIG_PARISC))
+		return -EINVAL;
+
 	current_bits = get_current_mdwe();
 	if (current_bits && current_bits != bits)
 		return -EPERM; /* Cannot unset the flags */
-- 
2.42.0



