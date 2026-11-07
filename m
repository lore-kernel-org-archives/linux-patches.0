Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062140;
	b=ZIJviHsZgOIQyWYIcAzZaBC3ykubtsiEV3OklS7JFqvOjQdPuqv7iJrXpLRpesbFqXQd
	 CStbxJ6Z2Sw4Vh/tyyC2JcEvix9FUc2RSXdL8WeK4GtH6bMdqpWmojJFqtiaX6u5UL/IB
	 wKqUGEGtc8+YvWAQwEaOgWd3bBx+5AHhOrRvo02SfXrAiCK2tg7+qmXPtfKa4nmzLA4+A
	 X1LM9gDns9ZVNe+Fy7VuLjQp72aQt5GDf2neeWyvrkmFa1y2EIb0L0fb0M1UFz7KyUFXw
	 U1Mk/6h53HJPkj3YUEY3wvrz/S73UVuhYvFWH74qRS9TS1fEfLKouxgur1Tn7B/xjgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3lexRMWh8C0yz5RUZRqks9MfHZ4ks415+FoyGhl//90=;
	b=P95FnogdNkj78/T+kpn75ffZzVEcBQx6DplnothiL+vW8JkwJ82lU4JPcB7hvMVIp/bM
	 yzIYkaDjuKawL/DhJtyBYgmKCkhZnLmxqc3ucPN8dMuIKWA24YUH2bX11CZOx/V6XV2V3
	 M95a22T/2Y4YksvoPTx/l+N4PHaqiLZJjsbl+zHfC3JfBAX4oxu9EJM1cy8O+zWpcNVZe
	 RgppTL8UhUOl+I3ZQbK6WAQyHXKJYerYB4HIJipUY4sXApJsYYAlYu5iZ6N+PtQC00re6
	 ao1h2p8cwpaK3vAvT2RpN74KNThv7kryum1C+y1/q4kuz3NCenHNunJsCgXDdr+HQlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC2yxwN6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2460606A653;
	Sat,  7 Nov 2026 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hC2yxwN6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8DE1F008A3;
	Sat,  7 Nov 2026 14:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062139;
	bh=3lexRMWh8C0yz5RUZRqks9MfHZ4ks415+FoyGhl//90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hC2yxwN6XHyqjRrVguoWdspPxL0bKo0v/h1+eocKmxHssELJ/oMk7jqJ0RAkOIBGC
	 RCySxuGFmQboRf3fUTZ4YXwz5itBhYH/BpBBrIOmINtC8UtBl+1wQZWnhtGI8KEDa+
	 5n0rL/o2P8jTNmqGEFUjeojKdlK+ebVS0l4JL/IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1105/1536] pseries/plpks: fix error handling in plpks_read_var()
Date: Sat,  7 Nov 2026 08:52:01 -0500
Message-ID: <20261107135028.738362042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



