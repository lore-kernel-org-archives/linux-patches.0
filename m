Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626116;
	b=rFxP84mU0a2LbrvC4ZNfU5y+kvrQL9vWx0lOl7JkvNT5sB693+kIrFXEaRQDRL4nKY8X
	 RNDtjn35ZK54fAmnwznAsuf1gniuilW0bIlLj3cpH1WACP4vhaM0uqyY2rsc/YNY+9PAz
	 tIp/GMbhIfmOA0R1lHLDq98O1BI3+rol+2PFW4kHODnBg3cZViiMwH6VlUGCGBE16A8Il
	 t4JR1DPkmKLApQM6IoP3R4cv33WqT2JUrJxoh1xLQVkCwt5T/6LxDKQdg5rfiq24DUD07
	 Y7HoBGxNGrBUs2t6YnEXJS4a/6ZLTVo7N+EFqPuucRWEQB1rUJCh2gwcl6HqwQLtXEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aneNIa/XrkoyHGBSuVydtNbm+vdJfR0H8eC+14hMIDA=;
	b=AoWX7W4Ld2OpDkQ7E4p0Pf3y39obI4V49RKaQnfOV9yemPnfUJEMj2MpGhq6ogdZzEgj
	 fiCk/5/jyYZJ9e64DE4cSMVAI1NqjgHLV5g4czGXNY1V816JlMVyBLWqsrOynX7qbAasP
	 FMrkOeNty/PW4Zl9gM3H8Or4oRjAjrA1Kg8S/L4x8FwoJ3T9txDQf8bBEJZm5xfF5os8l
	 01KNOcbx2OHmjwkXp+EjEq6rUhaFoUZhCRuV2XXJLGJCEPpYz0q+fuw8IgkDWiqU41Qiw
	 dryk0pgFeAxeIzIi1Wj4NW8/TTReo4xkofz5I9nJ9R/KVe4Q/y0xHWEoFjUHVDTBvzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQaeUvbg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBC8606A31E;
	Wed, 25 Nov 2026 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zQaeUvbg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7CE1F000C4;
	Wed, 25 Nov 2026 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626116;
	bh=aneNIa/XrkoyHGBSuVydtNbm+vdJfR0H8eC+14hMIDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zQaeUvbghM4mgbd2H0vX+q0EPnKEAap0OD4Pj4xwZhy7u0dH5a7n/QaUvpsJeni/n
	 UeJ2B7sHO3phU/oCKvVTLhjFqVVhpic51JG5/DOrlf1d7ZDuMmeqdixRPtW7IEBP1+
	 iI2VXuccSMO3cQVYU4RTOHSDMVilZp7h2xtQq/nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Subject: [PATCH 6.12 736/816] tty: fix misapplied compat_ptr() in tty_compat_ioctl()
Date: Wed, 25 Nov 2026 15:38:04 +0100
Message-ID: <20261125143906.214911749@linuxfoundation.org>
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
@@ -3007,8 +3007,7 @@ static long tty_compat_ioctl(struct file
 	if (ld->ops->compat_ioctl)
 		retval = ld->ops->compat_ioctl(tty, cmd, arg);
 	if (retval == -ENOIOCTLCMD && ld->ops->ioctl)
-		retval = ld->ops->ioctl(tty, (unsigned long)compat_ptr(cmd),
-				arg);
+		retval = ld->ops->ioctl(tty, cmd, (unsigned long)compat_ptr(arg));
 	tty_ldisc_deref(ld);
 
 	return retval;


