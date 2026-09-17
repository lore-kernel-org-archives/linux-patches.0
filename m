Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2003749739F;
	Thu, 17 Sep 2026 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660143; cv=none; b=ptaNX1ns5lsB3lz6bj5Of3OdDPXQJfoKrSNKksHCIKH8H+B/ofbExg0nzD8tMsipfrYuUZb/zKhQyectdYiqx8OEhdxubkjY6GZ3QFUfdEu0HpwOe4ZbOG4y+jCSJ8HNI8eM78yen7w7y1cg/vZz9Pr4ARLtxutY7mq/rR4DPLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660143; c=relaxed/simple;
	bh=D36EZ2EeKwlX38rC6v7mtGN6X7GV33/jZBgc48482l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpzTwZyBRTV4kfmSFZ1+hS9JeUrkR6XpPu4IJYWNkhZfI4gbSHJLrXu8fiAPN9YVLN1PASzedBAfjrsR40BssNmBqL+gTrEjEaR7Mbqmn2ykLkIyAE/DMhzQ3yH+152720HEvZPCDjxBetiv6uDVqLRk63LK/pfEVdpLGmY93vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dc1m8VJs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dc1m8VJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906871F000FF;
	Thu, 17 Sep 2026 15:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660139;
	bh=E21vXvjY7mz68TWlbCrsD4N4BKydQM8hW6UhqpyzZtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dc1m8VJstmQeNPJryJ/0H/NPJgIBt//JykIRmfSeRxyuSCJBhL6NqNaH+v9rAEHi4
	 YsLugfcO0Yi7MUUdzhUuQf2UXtq8Yn/uahfEYRwfC0dUaPzha95qCKyMhxDNP8wsF6
	 rRacwSDbonVJSW2Jmey3IknnhQ10j3CwSQzkRrXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jason.andryuk@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 7.2 455/733] x86/amd_node: Fix potential NULL pointer dereference
Date: Thu, 17 Sep 2026 16:12:43 +0100
Message-ID: <20260917151403.257254756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit aefdbd574a362dcf7569bada6d72f64a006b9fb9 upstream.

amd_smn_read/write() are exported functions around __amd_smn_rw(), so
they are always available even if amd_smn_init() fails. In that case,
'amd_roots' is NULL and __amd_smn_rw() will access uninitialized memory.

Then, commit:

  83518453074d ("x86/amd_node: Add SMN offsets to exclusive region access")

added the 'smn_exclusive' flag, which indicated the calls to
pci_request_config_region_exclusive() succeeded, to prevent
concurrent userspace access.

Commit:

  0a4b61d9c2e4 ("x86/amd_node: Fix AMD root device caching")

re-ordered initialization so pci_request_config_region_exclusive() is
called earlier and a failure exits amd_smn_init() before allocating
'amd_roots'. The setting of 'smn_exclusive' moved to the end of
amd_smn_init(), after 'amd_roots' is allocated. It became redundant
and can be removed.

Replace 'smn_exclusive' with directly checking 'amd_roots', to fix a
potential NULL pointer dereference and to simplify the logic.

  [ bp: Reorg commit message, touchup comment. ]
  [ mingo: Rebase & further touchups. ]

Fixes: 77466b798d59 ("x86/amd_node: Remove dependency on AMD_NB")
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260825214805.39148-3-jason.andryuk@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_node.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/amd_node.c
+++ b/arch/x86/kernel/amd_node.c
@@ -38,7 +38,6 @@ static struct pci_dev **amd_roots;
 
 /* Protect the PCI config register pairs used for SMN. */
 static DEFINE_MUTEX(smn_mutex);
-static bool smn_exclusive;
 
 #define SMN_INDEX_OFFSET	0x60
 #define SMN_DATA_OFFSET		0x64
@@ -91,11 +90,16 @@ static int __amd_smn_rw(u8 i_off, u8 d_o
 	if (node >= amd_num_nodes())
 		return err;
 
-	root = amd_roots[node];
-	if (!root)
+	/*
+	 * Uninitialized amd_roots indicates pci_request_config_region_exclusive()
+	 * didn't run or failed and thus the kernel cannot rely on having
+	 * exclusive access to SMN registers so prevent that.
+	 */
+	if (!amd_roots)
 		return err;
 
-	if (!smn_exclusive)
+	root = amd_roots[node];
+	if (!root)
 		return err;
 
 	guard(mutex)(&smn_mutex);
@@ -313,8 +317,6 @@ static int __init amd_smn_init(void)
 		debugfs_create_file("value",	0600, debugfs_dir, NULL, &smn_value_fops);
 	}
 
-	smn_exclusive = true;
-
 	return 0;
 }
 


