Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217154;
	b=BzXpLSbacmRn0Tm/BNWFE2PVrU2znDdFcEB2zlszHuIngHcEyv7oQxpCcGha7dDk5IVO
	 ZWhNPDDwpppq0vVdArQgCP6dat49AliqVswKvhwC3mvR6V//OEPpBbGxlZXLLolFmzMt+
	 PU4V0fJHvJeyYbVzf6diggZGZ2ijgS1eSQbvLCHmscAmUsglu4XlU05qoSPh6yD4+9Am4
	 REfP0RcOPtkhA66Dlg5eue+57L8uAXqPnVtfnSQQ8Blar8Mi4YJ9pSYuCwiLfbIu06oWO
	 1e9EpY58nd0zyW20H9gpXbaHoNUquVN9Lok8xql+rqAiTN0SikwMdFMePbQ0V3a9C7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fugsuug1rq1tTlv87pRBDcC7keWjFe2t3bzBl9loU2Q=;
	b=Z5tVaahtXZ5SQSh+OUu26LsRPkj29GtXA8W+vPSDAk0ll0j1cAyUSx7J/xdg57/3nRzZ
	 +67Du3RB90ZRdAfrd+6Ab8JmGT6puLVSsoNPA+0gkCSaqowNv2sdiAeVMmFFFLGYlVqee
	 Tp79dUR4tne+0AwWLTwH1gV1owwxu1ylicnbLu4fkPBEqY50IXVkwMzMahyyKAubSk70q
	 wElQO2NOqnV7WZhlII6vJlnl0OrCjSf+jZ1RPksK9cFzQunfFru5LSla27PacRsbC8d20
	 coVwJOdVSPl2Jcg6DoCfY7NU5RYp/DhuVt7bcBIBg0PeoL7JVOiHfnDKI325M/oXrGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBu3DIGP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FBF606A31F;
	Wed, 28 Oct 2026 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XBu3DIGP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5486D1F01825;
	Wed, 28 Oct 2026 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217153;
	bh=fugsuug1rq1tTlv87pRBDcC7keWjFe2t3bzBl9loU2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBu3DIGP+4a7C9gB2afQ44OFv51McueOl0+CyJaBxFgGYr1/jQJzL70VE76hfHQem
	 qGSJkooF/PnszSpDJUfqXfz19SpKIuRw4iwnrTkZCDFpKYM7MC8FlQMZCycMIml+pP
	 /PabHFT6bXOoUTWa7pdbYwLz/JEn8Z2W3Nkd8VJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 1807/1887] keys: Protect the type name while describing a key
Date: Wed, 28 Oct 2026 18:05:03 +0100
Message-ID: <20261028170540.568475192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

commit fced7238b7e80cf8aa688d5af976e4aa6e33c329 upstream.

keyctl_describe_key() must keep the key type's name alive until
kasprintf() has consumed it. The retained key reference keeps the key
and its description alive, but does not pin the module providing its
type. The name is passed to kasprintf() without holding key->sem.

kvasprintf() uses the saved name pointer in two formatting passes, with
a GFP_KERNEL allocation between them. With AF_RXRPC=m, a task that
passes View permission before type retirement can overlap a privileged
module unload in this order:

1. KEYCTL_DESCRIBE looks up the key, saves key->type->name in the
   kasprintf() arguments and completes the first formatting pass.
2. While the formatter is delayed before its second pass,
   af_rxrpc_exit() calls unregister_key_type(), which removes the type
   from the registry and waits for key_gc_keytype().
3. The collector takes key->sem for writing, retypes the retained key
   to key_type_dead and completes retirement. Unregistration and module
   exit return, allowing free_module() to release the type and name.
4. The formatter resumes its second pass and reads the saved name from
   released module storage, which can fault in string().

Hold key->sem for reading across kasprintf(). The collector then cannot
retype the key or complete retirement until both formatting passes have
finished. If retirement wins the lock first, formatting uses the core
key_type_dead name instead. Release the semaphore immediately after
kasprintf(), including on allocation failure, before copying to
userspace.

Oops report as below:

    BUG: unable to handle page fault for address: fffffbfff8054794
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    RIP: 0010:string+0x23f/0x470
    Call Trace:
     vsnprintf+0x330/0x1110

Cc: stable@vger.kernel.org
Fixes: aa9d4437893f ("KEYS: Fix the size of the key description passed to/from userspace")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/pm-key-management-objects-candidate-0009-v4-6b537c5732fd957c33fa@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/keyctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -677,12 +677,14 @@ okay:
 
 	/* calculate how much information we're going to return */
 	ret = -ENOMEM;
+	down_read(&key->sem);
 	infobuf = kasprintf(GFP_KERNEL,
 			    "%s;%d;%d;%08x;",
 			    key->type->name,
 			    from_kuid_munged(current_user_ns(), key->uid),
 			    from_kgid_munged(current_user_ns(), key->gid),
 			    key->perm);
+	up_read(&key->sem);
 	if (!infobuf)
 		goto error2;
 	infolen = strlen(infobuf);


