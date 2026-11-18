Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029892;
	b=c5ui9WhmGdNAiKDIsCKmISXKKeUGuKkh7mOG5esrq901oQCtiHCPXDUncJUWMSuNL079
	 TSeC574+KYf0DrFzY6AmGHIiZ5nrrltY075ntRhDtGRoQoc2g3gXc8U0cbl4QaLkFPDJg
	 6xZeyUuEj4+gI4hLfSfR4cdG4EZ8zYaLMil/I7sthgciX9NF8eJ5By/JrmTUAvSKs6nUA
	 y2qBuCaHbK8uxShysHy0ZCs++FoXxP/h12Ni5v5nEzIKk9zwpys/PIELoWZiLS5x+dUIB
	 ZF1mQnpPBUZFAFyNfTMaYQgUujxVd1qJkMJf2NwfedtX6tnV/tPVXr+dQXAa0JRGlkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y+/FOLSQs8xfaratRq+HZxT/7LjbkDzxfmSr5kz8BXg=;
	b=uNReVED1nPQWu9qt4QT66naGrYObXejShIQFsmgJ1tJE938UOOrU0h6CcCtwzgxPEVHC
	 mOBTMqJjBJcLWS1F67YXbnGRn01oVMs8UKlZI0gUJdU3UvYaCnsqL1csODeBgP8IpvFMI
	 uKQem2yJsPClOiR5b8xRvTIjFt4+CtanlmYUA8MOFXIUqWsNpa7bvUIbd0ryWLefgCPZH
	 6cxtkfbbw2W18GEVGMnIwrggfbKD/tqXnapXg0AdYHYnEFDY1stXM0WSQr2OrCnSz3YXX
	 81ywAURxcNwfctAzkJ1Xlp8Qa2HWI+gqGF0BOSmUkFZTz64iB96qzPbk7WMF8bWPEsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HckfcPVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C2D606A333;
	Wed, 18 Nov 2026 19:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HckfcPVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF63C1F000CC;
	Wed, 18 Nov 2026 19:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029892;
	bh=Y+/FOLSQs8xfaratRq+HZxT/7LjbkDzxfmSr5kz8BXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HckfcPVTkSBmaHPNy3yXEYPPTtdbtfGnsCcgCNLYP9xfONDenwxEqxxK4CfDE1RUO
	 QgBX8s4BJXI/9+Elu9k2QvlYht/98XMrPTr2CUDvSsiLzHlkTc5ok3UdyQHWBrb5r/
	 Yymngvi5ZPE2JRt+u8VLyOdf8MsC+MEHdGIcOZo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0509/1756] RDMA/siw: Fix qp use-after-free in siw_get_base_qp()
Date: Wed, 18 Nov 2026 15:43:56 +0100
Message-ID: <20261118150029.416520238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ef15197f81ffedf29560edf2221199d92fd83dc2 ]

The reference taken by siw_qp_id2obj() is dropped before the address
of the embedded ib_qp is taken from the QP.  If that reference was
the last one the QP is freed and the pointer returned to the iwarp
core is dangling; the core only pins the QP with iw_add_ref() after
the call has returned.

Copy the pointer while the reference is still held.

Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916184400.2093106-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 14d3103aee6f8..0e53bda4f5a12 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -218,8 +218,11 @@ static struct ib_qp *siw_get_base_qp(struct ib_device *base_dev, int id)
 		/*
 		 * siw_qp_id2obj() increments object reference count
 		 */
+		struct ib_qp *base_qp = &qp->base_qp;
+
 		siw_qp_put(qp);
-		return &qp->base_qp;
+
+		return base_qp;
 	}
 	return NULL;
 }
-- 
2.53.0



