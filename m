Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063048;
	b=L+yxj5NyOONUB0re2ucLHB0Q0m/cdbj0J0Cv7Y/TmrTXdQxb20Xu/MHXcmvH8cStz7WS
	 yGdOxcJ73JTB34DXhqogVG4mfIN/KgjdDYUE0doC84Q10VN66K920UdJjkAQ9xeKPEv6s
	 G5XIaGJxubQNpEUkD0oa+xeZar6GtFL3Eue70Hk5uxw8nvbh92JSEZ5JE3s05+eh8HoZn
	 X0t//4kO2+ZWKv158/iHP6GLjZSdOKeDitYMZ0c5GpRZnoY74Js+9pCXuya9W6P+A3eKj
	 m7rPWTUYsRa33bB8a0UgrH51zDpEuYjchSQ3CeS2o5pZ3JmbFHHCj1GdNOGKYNvlUwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bZpHpZFaUwtnG/Wcc769QJ1PtNHvEn/eggBEMymVl/Y=;
	b=DwcNj+USj0jp8wYsaW0PRyXCPa9hOz77trv00JGm+eUsDjfIOp+lBAEb7ALmXSgeGfBJ
	 aUT+YWytz75rV9QIqvAIT9/sVmYQKBsyMm0xkR+koR6IGHx83UiqDMpQfYemw9PwtK0AD
	 8P/sgQrk8ybS5NQ6b2SzpFvifR9MxUhcRGxaScPcSYvf1eyVWX3CZ17sb5BPBx+wvr/Uy
	 1qm9jOQrp/9kyuIwSkuwaHLvhRf4ChtbRNki7XzkwTnHvdCGrSeoyIAQPJitAynVQvH0T
	 p9fzACjWktqsClSg4FmKjX3rgE8Q4TSE2D2iWpKwvoIIFYh2A4OnSuhuzBm+ZxQ9lbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZw+GAGN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173D5606D808;
	Sat,  7 Nov 2026 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZw+GAGN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E171F0089F;
	Sat,  7 Nov 2026 14:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063047;
	bh=bZpHpZFaUwtnG/Wcc769QJ1PtNHvEn/eggBEMymVl/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZw+GAGNtgy8Gy0L17om85qZk9VrlwRxwCd4nlimDLJ3itvL01bT3Ms79arKgLo4/
	 ElZceVQVEV/TB723+L4gUkimgYg/QFmLTZy95KAov5G5/c+7wewPw9uSEK91ut+8zv
	 Q9XCrHH4ifsKflJpagf/leM8TEVHBP3uJ8oIlJ1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/869] pseries/plpks: fix error handling in plpks_read_var()
Date: Sat,  7 Nov 2026 08:49:35 -0500
Message-ID: <20261107134901.885003372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit d52a1659cb1718f93166ab8dd8621237e564a1c4 ]

When a PLPKS variable is initialized without a policy and used to read an
object with the PLPKS_WRAPPINGKEY policy set, the hypervisor returns
H_AUTHORITY along with the object's policy. However, plpks_read_var()
currently treats this the same as any other H_AUTHORITY failure and returns
an error without propagating the policy information to the caller.

Distinguish this case from other H_AUTHORITY failures and propagate the
returned policy to the caller while preserving the authorization error.
Remove the explicit assignment of zero to rc on H_SUCCESS, as it is
redundant.

Also validate the PLPKS variable pointer before dereferencing it.

Fixes: 2454a7af0f2a ("powerpc/pseries: define driver for Platform KeyStore")
Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-2-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index b1667ed05f988..1ea3ef0a36254 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -562,6 +562,9 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 	u8 *output;
 	int rc;
 
+	if (!var)
+		return -EINVAL;
+
 	if (var->namelen > PLPKS_MAX_NAME_SIZE)
 		return -EINVAL;
 
@@ -593,22 +596,21 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 				 virt_to_phys(var->name), var->namelen, virt_to_phys(output),
 				 maxobjsize);
 
-
 	if (rc != H_SUCCESS) {
 		rc = pseries_status_to_err(rc);
-		goto out_free_output;
+		if (rc != -EPERM || !retbuf[1])
+			goto out_free_output;
+		goto out_copy_policy;
 	}
 
 	if (!var->data || var->datalen > retbuf[0])
 		var->datalen = retbuf[0];
 
-	var->policy = retbuf[1];
-
 	if (var->data)
 		memcpy(var->data, output, var->datalen);
 
-	rc = 0;
-
+out_copy_policy:
+	var->policy = retbuf[1];
 out_free_output:
 	kfree(output);
 out_free_label:
-- 
2.53.0



