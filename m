Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A7B256C7C;
	Wed,  5 Mar 2025 18:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198757; cv=none; b=m4f5SekbVtDeM/pxu2uAQLfzKB4hHj2MBuN+faWEMGsVHBijxyES0A/EnzfFkOk8o9jIq4WWy5TAeydwgrERHlBOmaVzrxmqMgyhDazS0sdYI4IcMwosfOT6Qy4H5cIocml9lk9MUkkWmv7wDcAAjAAOFpRygrRk83mqL3KEgOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198757; c=relaxed/simple;
	bh=SOWRPqBKaoJx9Y6k3qeqrEIzhGOpAuIMvJNo1ZvD11w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKVXbFWuwQmhWlSC1v+eMJEx254k1d8wmF5jC94wekajgO1zXjrEgOxgstKVwUdHRypu4Zt1Y/+Eoipruel45Kvf6gdf3WS6/qDiN6lBZXSi49l9mnsSw7HVNCkXI+YZ5qIleRCdOohtVnatmUdyeUI2sK9OStGjn4Es1j1hSGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkGhoOOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkGhoOOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C80C4CED1;
	Wed,  5 Mar 2025 18:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198757;
	bh=SOWRPqBKaoJx9Y6k3qeqrEIzhGOpAuIMvJNo1ZvD11w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkGhoOOFbGJL6K5oIydK+90JJP7rxqTKtCE+XRKJtCaajhAEVYvnaH5uenSq40ZmY
	 qrkTc3DS/RaESsCg6Z5ZtRG1PJorM0vTAOScWHkamKJ9Olv3+VGbkYYjSs0zQwc7Tp
	 tZ57w88hZxfF9r2/ejOv6MybuvOXc6xDd15v3pXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.13 138/157] dm-integrity: Avoid divide by zero in table status in Inline mode
Date: Wed,  5 Mar 2025 18:49:34 +0100
Message-ID: <20250305174510.848520007@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <gmazyland@gmail.com>

commit 7fb39882b20c98a9a393c244c86b56ef6933cff8 upstream.

In Inline mode, the journal is unused, and journal_sectors is zero.

Calculating the journal watermark requires dividing by journal_sectors,
which should be done only if the journal is configured.

Otherwise, a simple table query (dmsetup table) can cause OOPS.

This bug did not show on some systems, perhaps only due to
compiler optimization.

On my 32-bit testing machine, this reliably crashes with the following:

 : Oops: divide error: 0000 [#1] PREEMPT SMP
 : CPU: 0 UID: 0 PID: 2450 Comm: dmsetup Not tainted 6.14.0-rc2+ #959
 : EIP: dm_integrity_status+0x2f8/0xab0 [dm_integrity]
 ...

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3790,10 +3790,6 @@ static void dm_integrity_status(struct d
 		break;
 
 	case STATUSTYPE_TABLE: {
-		__u64 watermark_percentage = (__u64)(ic->journal_entries - ic->free_sectors_threshold) * 100;
-
-		watermark_percentage += ic->journal_entries / 2;
-		do_div(watermark_percentage, ic->journal_entries);
 		arg_count = 3;
 		arg_count += !!ic->meta_dev;
 		arg_count += ic->sectors_per_block != 1;
@@ -3826,6 +3822,10 @@ static void dm_integrity_status(struct d
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
 		if (ic->mode == 'J') {
+			__u64 watermark_percentage = (__u64)(ic->journal_entries - ic->free_sectors_threshold) * 100;
+
+			watermark_percentage += ic->journal_entries / 2;
+			do_div(watermark_percentage, ic->journal_entries);
 			DMEMIT(" journal_watermark:%u", (unsigned int)watermark_percentage);
 			DMEMIT(" commit_time:%u", ic->autocommit_msec);
 		}


