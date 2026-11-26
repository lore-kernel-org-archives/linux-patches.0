Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705599;
	b=hIIaG78TQpPHhivMnim+QE0NYNxo6Znw9DEn4AP9WDLtt8iUSbHBTCp1hFor1ALLCigx
	 u6DAYcGGTUfe8BrpploOAXeDeV+K2sSanFl/Dn8a4CyNk4YB/k3KoHRk5Jj3ruTapLIVT
	 nYVHtS1jtZXPa0XRn8PWNGKvkVzJThk4kdptGQz73+W4gxEGHg4imdr8NX1cd0WRqbptZ
	 00hYLq7YGkJaUzrTa2jcAFVspW+TXZzxdPo1BjQYk4w3QrWl/q42JRy1N1tTOG0hCe63r
	 U18lkKy41BX/8VREdyXpwuHJiCqDHP5gCh7NK1qBNM9uJxZMdRB4ALdHiC3uz/dzfqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RS2Nc4FHAjCgd2H3zgvPyAnX5SxHVtG6isjxPB0kaL0=;
	b=sEsRQ2cc7dJcbTeG8dMo85R6GN7154EqFHcu9SsZscMDstxlmg1ZusIVgZrlZPwwrz+4
	 Br4fj6jauQaMk6z2csf4PCaByv5VPjahrLmvGE+VgLLKddj3B6VXEpcAgH8fkYr5/KQ5v
	 D8zhbZmew94EZu7ogw7MOHRS7SgZCHROAu7O0lg/UFvsKmZ6WljfQ8phRdcpucwYPl2wf
	 PcVClT7fovRTMTQieCZ2rkbtFyjgymss0NvL6NCvkyj99mup88wK9ZCVhGgHD6PWCpoHf
	 UfVEovKoOJPUpto+oLI2L4VOdru0gB2N5ZCWca2u4xtoZda4hrYQuP+txOltK6u72Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyuaRXQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E4B606A31E;
	Thu, 26 Nov 2026 15:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cyuaRXQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968E91F000E6;
	Thu, 26 Nov 2026 15:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705599;
	bh=RS2Nc4FHAjCgd2H3zgvPyAnX5SxHVtG6isjxPB0kaL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyuaRXQwVXHrpH9eQDfuMYiOn46ISOOab8NQHxrPBfoJ/tdLcvTitcpg4jMDrS8kC
	 vVtDJ6FEPGDEjnL5RhZaPJ/6OHYt4f2fzZuOmyQ236KYRVrW0uqls/sRXZDYmdXI0X
	 jQG44qAWOYk7LXGQluKfuUtM1yY7BZh8p+APnorQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 251/319] dm-cache: fix NULL pointer dereference on open failure
Date: Thu, 26 Nov 2026 15:40:19 +0100
Message-ID: <20261126144012.409618260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -760,6 +760,7 @@ static struct dm_cache_metadata *metadat
 		return ERR_PTR(-ENOMEM);
 	}
 
+	INIT_LIST_HEAD(&cmd->list);
 	cmd->version = metadata_version;
 	refcount_set(&cmd->ref_count, 1);
 	init_rwsem(&cmd->root_lock);


