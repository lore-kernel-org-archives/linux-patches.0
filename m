Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590940;
	b=rTlLshx/cELHp6W/yF1W76RJKQBu/JtCuQUrs3YyJA2OgDf70RvzJblyEPvDvx9Q+S/N
	 3SHB5C6ZtqNriUJN3MdljHf6naeBjhbeLBqcdemr0r2mtEiV51j1b+4e6BBaLztK9zrEL
	 gGt/II1R8JFDIepPHLcqz4yaIRfg6x7C8ygarfN6dTDB1qQd48WjW14O63rVTCLEjHMrM
	 TYW/sJKstGAlr5I9UsrhAJ7smAUXqZKTXxxq6o3A1BPiCyT59pYtO0wUQfkbtNWvCizXU
	 N0pZrIknU15oTnqrDNYVOAKiuMq9zJKpzEhUGysFx9E9m5Oh3iAQ7v4k2ZtLRurlfLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RxJXExarEiAwyEU/BkPu3ihLO9vHIb2/o4+HlgMN2zA=;
	b=3tDavFkJAhg3lfKDLafB+fBW78P7fBIgVSueEdDZjmEiuouCXMG0Jln2+Pq6oDB38/Xb
	 l/H6KoLjoXQfbDUHcK6zeX/CFweYrdnYdC+dnZLvosS0f/cknxZPgVzvjPYsBY1UoEnuy
	 MxJTQ3ioRcI4jUiHN26wNIeTIdQ2C9lTJIaFQ/sCZVAPaQGmc4baQTu+9aSffHdPoYNxH
	 scPurNjsZHKbFcqRdtJkfer3nZdXgHEbJCHgCmFz5/Zwfi1e7SrtMyN2gVJvzJ1+RlN5g
	 6SDIaSRNqKugZQ/QrmcAM/swv67rscOh+OG7dZuV7T833WPLDOPO1DCkUr9gEGxJvNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ln+E3CzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2CD606A8A0;
	Fri, 13 Nov 2026 17:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ln+E3CzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145B21F000C4;
	Fri, 13 Nov 2026 17:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590940;
	bh=RxJXExarEiAwyEU/BkPu3ihLO9vHIb2/o4+HlgMN2zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ln+E3CzIkRTe9hm2icGG2B1bKHndQBDEFtsizZ0YufZNZSwp8rN26GvXshiq0dfCy
	 cuageCHCLIa9DOT0DHjIfpjoiXwhqgspDM4bIMJWHkNOraE6vQt8Gh48HCPdMpblxB
	 nVHWiuQbdIsPv/DFjCu7LHUah/S760yo+QcapDnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/670] netrom: dont convert the maximum number of tries to jiffies
Date: Fri, 13 Nov 2026 10:44:48 -0500
Message-ID: <20261113153816.018206429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_create() sets the number of transport retries of a new socket with

	nr->n2 = msecs_to_jiffies(sysctl_netrom_transport_maximum_tries);

but transport_maximum_tries is a count, not a time in milliseconds. The
result depends on HZ: with the default of 3 tries, n2 is 3 with HZ=1000
but 1 with HZ=250 or HZ=100, below the minimum of 2 that the sysctl
itself enforces. Sockets accepted on a listener copy its n2, so every
NET/ROM circuit of such a kernel gives up after a single retry.

Seen on our nodes in /proc/net/nr: n2 is 01 on the Raspberry Pi kernels
(HZ=250 and HZ=100) and 03 on the x86 ones (HZ=1000), all with
transport_maximum_tries set to 3.

Use the count as is. The other transport values are times and keep
their conversion.

Fixes: 4d8937d0b113 ("[NETROM]: Eleminate HZ from NET/ROM kernel interfaces")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 16eb00a80bb05640ba628529fd258e4ddb100ecb)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index fb2cebbd2814b..5b61a4fc93ff4 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -459,8 +459,7 @@ static int nr_create(struct net *net, struct socket *sock, int protocol,
 		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_timeout));
 	nr->t2     =
 		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_acknowledge_delay));
-	nr->n2     =
-		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_maximum_tries));
+	nr->n2     = READ_ONCE(sysctl_netrom_transport_maximum_tries);
 	nr->t4     =
 		msecs_to_jiffies(READ_ONCE(sysctl_netrom_transport_busy_delay));
 	nr->idle   =
-- 
2.53.0



