Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058293;
	b=PVyhqGwriDiFAnPgYbL5uPQLUEiiZoMKzDRrofulhuHC1OAYJmkIaKwaae6ZUo4VHEH+
	 oMk/haZuZadSTeB1sXiEwYOANa+BeBx9qt6UhVVGWbIeDic8u1v5Z/ejeaTUJQaNyGVRi
	 yS8JlVbD40lcCfL+rH1RGGPSfz/NrW8hJwafGZS8eTOqJEQsPcVp06UHjN1PocXEvNa/L
	 zwNpZb+g/BFAOf+pqXmkxwakwqm7RshNlia3VchOWRQ7LAqs69mSZoajrb5Qo9skU4PKM
	 mzW8sDsprpY7TR3iN7GrdB0jF382UVpx3fy14QPhRVyobW73bkZvrQO9V7Uhdr4mMZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+xNg1IOrsLJlx6i5OXwmoN6QcJN3N8/yZhrbLPI8OYY=;
	b=W/SBq4ftaAsL8cpJdrkAW92zSUvPNxokBA8fcHO4B02/MVjRLWv8pzek7JlkbKHKtPbp
	 HW+96B7ITPtiskDNtH6FkejcxbRC+dIvLzBezQ9FSuAsCJX1NwCs/p8vC5eWFeKrZ9Wa+
	 avPEkr7pF/ZQ5QsBU15GmwR47T8nO3Ln58LqhiTabrvjGXuBvstYCcvaghCwVBqcCc9Zf
	 PiVIhEk4YqyWUsSg3AflApwoE8OVebqgUllkuf7Fzg4O+xSTjtXRwrsOrRMv0E2E9luTn
	 cc+tkoFAHbadcjpbD9fufw2ripBeNXJuII38tkFllBdyTn6mZNcRSLetIUPKJ0GT2VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKhXOv2G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434E2606A320;
	Thu, 19 Nov 2026 03:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eKhXOv2G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9EA1F000C6;
	Thu, 19 Nov 2026 03:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058293;
	bh=+xNg1IOrsLJlx6i5OXwmoN6QcJN3N8/yZhrbLPI8OYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKhXOv2GqNWKYto2DKxe/a5XvrJxWBlk9OrrIbo1pBOMh83SFvY/au5a++T391zwF
	 NfZBI0VdLz145/hyoJX+gtAreOzRcZYvZaqHBAyzdgTU4KAQFd7vYQH/JwCdHvI7Mu
	 IEqFTEgpQ9nX/uPTI7Db0c4SwObbqvCjyKVC2wiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0433/1848] regulator: core: Fix coupled regulators reference leak on removal
Date: Wed, 18 Nov 2026 15:41:11 +0100
Message-ID: <20261118145932.263686579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b9205f0837ca91a0bbe6aa9002207656840c1406 ]

of_parse_coupled_regulator() returns the coupled regulator with its
device reference incremented and regulator_resolve_coupling() stores it
in coupling_desc.coupled_rdevs[]. regulator_remove_coupling() clears
those pointers without dropping the references, so they are leaked when
the couple is torn down.

Release the reference of each coupled regulator while removing the
coupling.

Fixes: d3d64537c339 ("regulator: core: Resolve coupled regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917143052.2156903-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4ea977af2eefe..698c3d35d322a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5214,6 +5214,8 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 
 		c_desc->coupled_rdevs[i] = NULL;
 		c_desc->n_resolved--;
+
+		put_device(&c_rdev->dev);
 	}
 
 	if (coupler && coupler->detach_regulator) {
-- 
2.53.0



