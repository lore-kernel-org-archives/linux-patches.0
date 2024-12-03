Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E1207A3E;
	Tue,  3 Dec 2024 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240275; cv=none; b=EsL6481fuAatCMffxvyDFVV6THj2UZde5OTIl98ciFxbRiTOJPX6XR4scNvSHLgTGO7qZSgFOusCW+sUvOmEfjIQtU0Hm36Q2X8lEjfESqxjeObiZ0BxV5t8fonprcluVFf1USuTM7kjjWqVO5ZnvV/nWH3/60k1gXRjU69fRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240275; c=relaxed/simple;
	bh=ZztubcMau+UPILwEb6c/l9cWh2YAt+BSXHvD5QJNfvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2LuCx5A1wOp7aj+KbATL0A5/iP/8jR0hhjQ7+5yFD85/1CVN2nBUPYaM5/hUOg5N6mM6MG0OQ2VrE2zILhiGxKo6dow9dxYEF8GaPY9Rp9LPqWzbGN4EqVHc01IMxHU9UF/u4LICc9qZE0CaBAhmD25tOEjSq6IIp3ICaIrkXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UOF4PQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UOF4PQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C496C4CECF;
	Tue,  3 Dec 2024 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240275;
	bh=ZztubcMau+UPILwEb6c/l9cWh2YAt+BSXHvD5QJNfvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1UOF4PQX0TYSGBzTKykNMU+s/6XqMY45V5e6U/l6aZx61pUTOvBp6f7fZKT1D7ibA
	 NuBXJnAVVW6MmORsH29vU/uRdoakmp60jIj1PMZ2oReyXurNfXNAL5v8/rxIMyD1re
	 ixg6841hCzkf68QGUnGylGBsHA7xM9EW1Dn4L3qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Will Deacon <will@kernel.org>,
	Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/826] Revert "scripts/faddr2line: Check only two symbols when calculating symbol size"
Date: Tue,  3 Dec 2024 15:36:51 +0100
Message-ID: <20241203144747.004525728@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 56ac7bd2c58a4e93d19f0ccb181035d075b315d3 ]

This reverts commit c02904f05ff805d6c0631634d5751ebd338f75ec.

Such commit assumed that only two symbols are relevant for the symbol
size calculation. However, this can lead to an incorrect symbol size
calculation when there are mapping symbols emitted by readelf.

For instance, when feeding 'update_irq_load_avg+0x1c/0x1c4', faddr2line
might need to process the following readelf lines:

 784284: ffffffc0081cca30   428 FUNC    GLOBAL DEFAULT     2 update_irq_load_avg
  87319: ffffffc0081ccb0c     0 NOTYPE  LOCAL  DEFAULT     2 $x.62522
  87321: ffffffc0081ccbdc     0 NOTYPE  LOCAL  DEFAULT     2 $x.62524
  87323: ffffffc0081ccbe0     0 NOTYPE  LOCAL  DEFAULT     2 $x.62526
  87325: ffffffc0081ccbe4     0 NOTYPE  LOCAL  DEFAULT     2 $x.62528
  87327: ffffffc0081ccbe8     0 NOTYPE  LOCAL  DEFAULT     2 $x.62530
  87329: ffffffc0081ccbec     0 NOTYPE  LOCAL  DEFAULT     2 $x.62532
  87331: ffffffc0081ccbf0     0 NOTYPE  LOCAL  DEFAULT     2 $x.62534
  87332: ffffffc0081ccbf4     0 NOTYPE  LOCAL  DEFAULT     2 $x.62535
 783403: ffffffc0081ccbf4   424 FUNC    GLOBAL DEFAULT     2 sched_pelt_multiplier

The symbol size of 'update_irq_load_avg' should be calculated with the
address of 'sched_pelt_multiplier', after skipping the mapping symbols
seen in between. However, the offending commit cuts the list short and
faddr2line incorrectly assumes 'update_irq_load_avg' is the last symbol
in the section, resulting in:

  $ scripts/faddr2line vmlinux update_irq_load_avg+0x1c/0x1c4
  skipping update_irq_load_avg address at 0xffffffc0081cca4c due to size mismatch (0x1c4 != 0x3ff9a59988)
  no match for update_irq_load_avg+0x1c/0x1c4

After reverting the commit the issue is resolved:

  $ scripts/faddr2line vmlinux update_irq_load_avg+0x1c/0x1c4
  update_irq_load_avg+0x1c/0x1c4:
  cpu_of at kernel/sched/sched.h:1109
  (inlined by) update_irq_load_avg at kernel/sched/pelt.c:481

Fixes: c02904f05ff8 ("scripts/faddr2line: Check only two symbols when calculating symbol size")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/faddr2line | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/faddr2line b/scripts/faddr2line
index fe0cc45f03be1..1fa6beef9f978 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -252,7 +252,7 @@ __faddr2line() {
 				found=2
 				break
 			fi
-		done < <(echo "${ELF_SYMS}" | sed 's/\[.*\]//' | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2 | ${GREP} -A1 --no-group-separator " ${sym_name}$")
+		done < <(echo "${ELF_SYMS}" | sed 's/\[.*\]//' | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
 
 		if [[ $found = 0 ]]; then
 			warn "can't find symbol: sym_name: $sym_name sym_sec: $sym_sec sym_addr: $sym_addr sym_elf_size: $sym_elf_size"
-- 
2.43.0



