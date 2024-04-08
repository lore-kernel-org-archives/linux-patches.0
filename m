Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403837BAF4;
	Mon,  8 Apr 2024 13:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582142; cv=none; b=O/XklCELTZNZ1Cs2PNR7K9jbMg678A5K63pj8CyCm/pVxDEc2ldtXRBxMDSwx+tNbcogGy8xrNmXuJNXOYaFDTdAdURtXwpEP/JrQYKKoeg3+64XWNo85WhYLEvlnfy15Zi5gLDDJnsNJmv2qSxp4y3owcXu1pg2urOvRFStta8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582142; c=relaxed/simple;
	bh=jBLdO0rouxu38U37pjDfMyRvFRTRiKlneL22Mbj0Ojg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHsS3D/g0uPOQPKMedfLBYbXvAaDhFU5RWnFd2rgptdodlpL83i4IIcBlTQIEEaAJZT6IzRGkht3p9PnPNGGkHAkzkMN26pzUk6T52+YbPQtEXtuZXx3LxR8MIiKapVLDRw/uV6zz7n8o9phm16EyYmMNmMjy50OjbqJ/pzVIK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsHV3d5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsHV3d5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B275BC433C7;
	Mon,  8 Apr 2024 13:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582142;
	bh=jBLdO0rouxu38U37pjDfMyRvFRTRiKlneL22Mbj0Ojg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsHV3d5zsIQ7V5qRgpBKf9+cnJL8HDm9ElAEOANBQdkpywAaNj0JrJnqK7WGBwYZy
	 yiBrHz4XoyoOBk0nfoC0j8EfsQ7gWCk3qCNK/erM+5GBGZUEvZyY0NSGf/jwwgGPvm
	 yNfhkEWNpWXadChYyLaMpVGSlONkSShckLj87mXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Pittman <jpittman@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/690] dm snapshot: fix lockup in dm_exception_table_exit
Date: Mon,  8 Apr 2024 14:49:40 +0200
Message-ID: <20240408125403.673075838@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6e7132ed3c07bd8a6ce3db4bb307ef2852b322dc ]

There was reported lockup when we exit a snapshot with many exceptions.
Fix this by adding "cond_resched" to the loop that frees the exceptions.

Reported-by: John Pittman <jpittman@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index dcf34c6b05ad3..d3716d5c45c23 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -686,8 +686,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	kvfree(et->table);
-- 
2.43.0



