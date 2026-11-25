Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623559;
	b=dKNMwb5+67KdHbUwzfpXkT/D9TfzF63hZ6GtgacbtboWRTAu9sld+sGDz1SxtcTcMWbC
	 1DS5Igy+XAomEekHU7ygCy/ec0A+uPRGEZ0n2eqjQN+6upR1DScLh4DhtahUnja/9Hm9a
	 DPA9JY3XWZDfz2O0CHZy7lg2m3zf+lXtHMpIHzo3EhbdwDx4KTthyhEbYkcNgrr5uj15N
	 8S2P3MSKsEhBxj3iqSxtNp0AnabnccWln4n9+JCEhGHIoADLp4lHQFMpqsy27Vqc38k63
	 T7w6vL+TIRuY1pSqd/0YO+v7kE+yj/8TBAfX+VIDO1Wwhpw6MciZ28ETP66MtQX71eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TcuXaawwx16ZaH5xRqbfEltmd+ngl/D/eGvDawqqeSU=;
	b=UwDFgomK6M2wjWqR/tjIUvxmX+UcER88AeiDbCjIXa23u8pGSS65iOd1RX2Cn3z7xQgc
	 ENR3dlNDVGatya24uHoIinVOdJ+4pUkYmA6m6UEgo04qBfgd2DeM78cAqU0lf1ZHj+NZH
	 zhlV2au+bDFSVrgPpWKm2O0Y+z38z5nz/5yR6+EuM66ZAZKwcSwA0V7HxEA78zvwgqNFv
	 IxCNn4VsZ3g+tF8wyRM8GiedXjyDwco7MvMtFwdAt/HlLTN1QpCpNRDqJM+Nr5XbDY2A1
	 5wqGJoYb2TAPwraBfUsbrC4c6twIfUujLCIdBPanbxiYazYa0gdgF9Vvc2CskUNN8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jn6l5mgq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E017E606A31E;
	Wed, 25 Nov 2026 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jn6l5mgq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CF31F000C0;
	Wed, 25 Nov 2026 16:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623558;
	bh=TcuXaawwx16ZaH5xRqbfEltmd+ngl/D/eGvDawqqeSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jn6l5mgqsJRbOhPJhYjwCEMCS2KL/jTfSqfws7q44dKuA03bSmUztCLa1METyG46v
	 W/Opp5XUxTRGaMPCCHyzAY7QERItvgjDG5NE2Pu5C5PbPCUuT0wTue4fZhThprhlTC
	 1G3J6cJj3KglKeojD9cUQ53mTSL87KvRQXzXo034=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH 6.18 899/990] tty: fix misapplied compat_ptr() in tty_compat_ioctl()
Date: Wed, 25 Nov 2026 15:37:46 +0100
Message-ID: <20261125143843.069744109@linuxfoundation.org>
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit 895dc0eaa2779ff46a0b2a20b5ce9eb0b1125cb2 upstream.

Since commit f0193d3ea73b below, `cmd` was converted with compat_ptr(),
while `arg` was passed to ld->ops->ioctl() unmodified. Fix it so `cmd`
stays `cmd` and `arg` gets converted through compat_ptr() as intended.

Notes:
2) compat_ptr() did nothing to `cmd`, provided it is uint,
1) compat_ptr() is no-op everywhere (was different on s390 before
   8e0b986c59c6 ("s390: Remove compat support")),
3) `arg` might not have been chopped correctly until 8e0b986c59c6. But I
   am not sure why noone noticed all those (7) years (from f0193d3ea73b
   to 8e0b986c59c6)?

Fixes: f0193d3ea73b ("change semantics of ldisc ->compat_ioctl()")
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: stable@vger.kernel.org # applicable from 4.20 to 6.18 incl
Assisted-by: LLM
Link: https://patch.msgid.link/63e9d84a1e8e23852423206cf3f8907aafc88f17.1793704520.git.jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2996,8 +2996,7 @@ static long tty_compat_ioctl(struct file
 	if (ld->ops->compat_ioctl)
 		retval = ld->ops->compat_ioctl(tty, cmd, arg);
 	if (retval == -ENOIOCTLCMD && ld->ops->ioctl)
-		retval = ld->ops->ioctl(tty, (unsigned long)compat_ptr(cmd),
-				arg);
+		retval = ld->ops->ioctl(tty, cmd, (unsigned long)compat_ptr(arg));
 	tty_ldisc_deref(ld);
 
 	return retval;


