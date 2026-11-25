Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623472;
	b=OehkNmqhsIPM1sDLyZwHzQh/Aow1uLDrNuOqKdPcJrBkZs0Na3PRXaKtdhZGUSGN1TLS
	 YXkD9RMPun4IJ4a0oDDd5xPt2tJWfXLBAUG87zBehuZo3zAV3Kxl1mvh61UlU31Sp2lV9
	 D8AczKY5XDV+LHsDVuOuY1T3zUazEpHvMdOrrTIU7gwSbHFeMK9xt2jv5ibt+n8Os2qbg
	 dW7KyJvSwiJZw56wXA9G8JTMAis4zS1jW3uWkB499099TbL77JbG1Gf4At1bN9+R1fgYG
	 qtXCcN5LR6GRAybnG886FLt0gDbKWtgY+cqDO+sem2FFRoUD1uEPAwuvLLRs12yyeMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tsxQM2w7NF5g6CzMiFojn1Uv2rFoCLYLrhkTv8h9PC8=;
	b=gjNgXB5H/CflxY61sJz8ivjC7o6UQx8aCgP0ThWdWnbFFLei44+b2F2XPp35Gtp/W3pK
	 mi7Ly/WfZe9Q3hFk2+zz3AF0o4+eEh2W77avPL5DhNVLfVyXEoPNKyAfARQQ2rywFauzG
	 d6CLNYZPIl2IHnWm73WoqXV++T7Zkh7CTppbSql95+t+aRguW4MamveMvcQHKMOCmedCX
	 /fJx1oc+qHRx/t+BPZbazpkFjJFuBPDsQs87EBvgvVaq56P9YCyfK8MyRWB0HFKST0z4F
	 I9fTKG6VnRzX8SGygcLRFH2fZffpGin8zvNYlk9kSU7AoRo1R1lThW6drq0LFXU4EEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4cRQ0f6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE72606A31E;
	Wed, 25 Nov 2026 16:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4cRQ0f6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4841F000C6;
	Wed, 25 Nov 2026 16:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623472;
	bh=tsxQM2w7NF5g6CzMiFojn1Uv2rFoCLYLrhkTv8h9PC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4cRQ0f6+kwq+tJUsRqftObfvuSO303KNMXKUKKG09E7zbRov5gHUMntsBNidsjBX
	 rCKnAewV+1pehIjqBpe01GcNU/qwYqRLSc6tOfAp8dG8OFkmbvCZzzhgUiv74ezXVV
	 Jn2rkFeIpnFAebXlzTr4qDOdxT4InXizfgvPuFvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 870/990] dm-cache: fix NULL pointer dereference on open failure
Date: Wed, 25 Nov 2026 15:37:17 +0100
Message-ID: <20261125143842.401177255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit d12afc2f9ed6e14019fed9c02a74ad699915dc85 upstream.

When __begin_transaction_flags in metadata_open fails,
dm_cache_metadata_close is called. dm_cache_metadata_close attempts to
execute list_del(&cmd->list);, but the "cmd" object is not on any list
yet, thus it crashes with NULL pointer dereference.

Fix this by initializing cmd->list after cmd is allocated.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 9b1cc9f251af ("dm cache: share cache-metadata object across inactive and active DM tables")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-metadata.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -766,6 +766,7 @@ static struct dm_cache_metadata *metadat
 		return ERR_PTR(-ENOMEM);
 	}
 
+	INIT_LIST_HEAD(&cmd->list);
 	cmd->version = metadata_version;
 	refcount_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);


