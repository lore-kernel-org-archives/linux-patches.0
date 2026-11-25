Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626165;
	b=gu2Iq6SSaSJu11ZtVqoD/dI27iiWpOeDUO8VHl/+Zw6ej4Rh88/kfxOnPQEW+N4Hgtv3
	 oLLbFi7giuYGQm3t8DUg7943659thFKehTDFo46dNJkFBCPkyvIeQmMDes7UIJ3k8wMrR
	 w2VbiiyhbchU0/Q6zeeNJYZxqkiJ/KksPqjlpl3mI1JHVkF71TQfV48Ow+p01hKxhp2Ny
	 2vY/zT7PKK9Gov4XgRX3y5gmCnNmPjNl9q8DBeUFDoAcsYHTfoNb23YNWS4EYCKQ4IeEV
	 9XWIlahpnHQypiWsimVndLQoxSxDHeCEnJ7k67Vpz+3JoTUC0vhNX94HXFUg5BMUlPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tG/OsSmITR1KHjXtImG/kr63+aHKi0qgi3pdhOg4GgE=;
	b=iIU4wJDR6bp3Lddk5cx/4JZm0s0CyYgDP2SN56KYNXvKzbK7hpaRDCI2a4vsc3si8tot
	 7q/nhbsdqNre5NGaYELBgxzWCycWBhQZ8BzXsjcPZ2inTLfONN91jahYuh+eB0siu6YA2
	 9JdXjaWHNn1Nxj+blul52g+BO8Sc1RKPehK+1mEJo2uqZQteeZVrWPErVp9cas6C6aD9S
	 bw8GpY8oxSaLBLC6OdMa2edCN8x2I75Dv34yA5oamI+dv5ixVnJK2LhizCjHCXwpEJ5aN
	 xsljnWTmCD7Gh0PeqWvkMnpMvlD/geI0jf7NXtEFw3jkgX8ZfhTwILpe17g9fr2dE8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApdKgAcd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59370606A323;
	Wed, 25 Nov 2026 17:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApdKgAcd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DA91F000C0;
	Wed, 25 Nov 2026 17:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626165;
	bh=tG/OsSmITR1KHjXtImG/kr63+aHKi0qgi3pdhOg4GgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApdKgAcdFEOYOIkMBkroSgElkG9cUZ+XSdTZrMo45eNyPJvKjQJq5x/buc/TPLv/Q
	 aBCHgDJPjna3E/wPOnjPF12iL2ByADaCuBescRCaxK7Yijk8PycSL2mytzOoGljxcI
	 8h8jUSqQ7wfRTFn4kxBVNxrsJv18LHTYS0jtUuDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 709/816] dm-cache: fix NULL pointer dereference on open failure
Date: Wed, 25 Nov 2026 15:37:37 +0100
Message-ID: <20261125143905.588632667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


