Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620313;
	b=j31qgcRMIbkDKWqGMSf2+lWZA9aRIgFQlaWkCxRAhBdcea5b4t3aqHbelVf/+hBpYmVR
	 l3EZc0LHuEYKBt69HpnRvKfaCuWgbVVYU9xO8fstywVxaEhRACOET89dS1khgsjFrl3nG
	 z96GpOOzM2Ei7z5O9uyo7zg8xpxsaeViD3c6Hmke4Z/DNSWjxg5IdVZvNbMEOsBExxwZ/
	 KJXvoZ6aCOQ309QPzy1vmtGtXJhEN79ktk/ka0uK4BFUb9kJCY88xS1XdEJCOX3HeZBz3
	 2wNSAveFkXd/MhlbNHgz7ACaX9jqdQADa3ydXGvVEqYq7C/cWun3AnVBhvKX/DlRVjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OgruR93WmSIn5aKQEmfidaCIGsndX0J2tNP4qAU7ibQ=;
	b=387R1H3phyzj75mZPEMPMiJC3+q4ru2WG3R1hZ3gLqMoGFzccnRx51D4seTLuU+8YjLe
	 V2nVDTTTOEhLRLgK6Uux6ljm79kz61Q1G022Opo2FQV0Tf52mcpPFjxoF6lJsX6OaQhHr
	 w4EaGPU/OeB4sxVSpAxJRxWxhW6vsrjUN2/iqx5GOiJZ3cj+w11Kq7El5+NWd9YkOLYLb
	 wVOXtTsoUpkpeZ+73Z64LfAveXJtIy05GYub2SCp8Rcj11iSFlOli7MO9S7P2vVwEDU4f
	 SXE09xqInaB77OwE06OUHxxiYrvXIebKC/pfGFHNhMFwEpsXR44/j3TwQ1E05K9d//g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFPrZie9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F23606A31E;
	Wed, 25 Nov 2026 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFPrZie9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD04A1F000CA;
	Wed, 25 Nov 2026 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620312;
	bh=OgruR93WmSIn5aKQEmfidaCIGsndX0J2tNP4qAU7ibQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFPrZie9fz83i3KPqzrd1m9IXKNgJDks/u6kMxzQXJhI0DwZy6J+d9rahV3bTFOD2
	 V0LdJZO8kB4WhHp1GoxR+gr7dviEOR4H/jR6H/qnUt51R7/lrIA2ZHletvPsblwoaM
	 QCcQlJRU0ZSCX5KNonDo/lbBAOOfUcSN5MfZgwmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0875/1005] dm-cache: fix NULL pointer dereference on open failure
Date: Wed, 25 Nov 2026 15:36:53 +0100
Message-ID: <20261125143842.203020856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


