Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7A734B19F;
	Thu, 28 May 2026 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000954; cv=none; b=GTa0012hwJCqYkVWRUXFBms5TbFU4Mhxu1VU+tTxZHUtIE0k+N6VtgSQ1LZjx7rJ85zDeyunAdtDuwMpMZjSYjQkfmO2+4WdDCL95hW5VdX8X+iAI03IXGCgIDU9MaGCyHH4dcHKRiLthOfIBQuRCAJMrWFfRvmL5aoB3ZQFHaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000954; c=relaxed/simple;
	bh=fVlyhHG4APa8xWMTEvhdEeomJnClwHOSNxEf/9FeHx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbtyh9g7FbUhnr+u13tZHYBFH32E0atTisTMMlXCGIzQgMcEgsjwTapzS4kt/ku6sN/FVdiu4UgZBSfU5HskwNFadKFA+RL+O5skA4tSTaIOsjlWwnQcmzBD57zVqv00gxi1Q6rY65CTk19Rn7+Z5JiGn3oBC48csS2Aa9xMlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elPHLHcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elPHLHcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2185D1F000E9;
	Thu, 28 May 2026 20:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000953;
	bh=Lop5hSru7TA5xScFzmU6wRW/Y4F8HqfN9aTwE6yl6+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elPHLHcjizVvFMRt9VniPGLJLakPphkZhNoA+t0gfeYsRVLxVptinQAliEgtJGXnt
	 tp8ynQx8luVmgVwebx3fWG/662nz4AlxVEs+dr1yQbdC/h4mSURxPbx5PzSXredeQk
	 Qug9HYgVWZONPcJgNivS3dyYrsU5EkUtqkz1EDCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/272] x86/xen: Fix xen_e820_swap_entry_with_ram()
Date: Thu, 28 May 2026 21:50:02 +0200
Message-ID: <20260528194635.563740604@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 28e03f78e69cf6628b81f24777799778528a84c1 ]

When swapping a not page-aligned E820 map entry with RAM, the start
address of the modified entry is calculated wrong (the offset into the
page is subtracted instead of being added to the page address).

Fixes: be35d91c8880 ("xen: tolerate ACPI NVS memory overlapping with Xen allocated memory")
Reported-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20260505102417.208138-1-jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 3823e52aef523..6260f65a78c5e 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -655,7 +655,7 @@ static void __init xen_e820_swap_entry_with_ram(struct e820_entry *swap_entry)
 			/* Fill new entry (keep size and page offset). */
 			entry->type = swap_entry->type;
 			entry->addr = entry_end - swap_size +
-				      swap_addr - swap_entry->addr;
+				      swap_entry->addr - swap_addr;
 			entry->size = swap_entry->size;
 
 			/* Convert old entry to RAM, align to pages. */
-- 
2.53.0



