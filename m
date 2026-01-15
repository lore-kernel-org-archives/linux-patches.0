Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6573D5227;
	Thu, 15 Jan 2026 17:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499602; cv=none; b=Hu/oNL7CToadFAlmrgRytNvxKE2q9ZwB1Jgrlz2M33RoIxCzc7kfGNXoRiq+S0Iqf+gIoRcdeoMBaWjybauvmjXBtR0sOKhQa7tJP3a0KOOFiwiY/Ke5HihthNlpAIFPOUjnRUITLj4iND5iaoRqTFz1wVjA6z+PRWGgHgscPNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499602; c=relaxed/simple;
	bh=HcNBOjczZJtRy52hBXgJ3UgZx1Bo0j4GVsS6UHUyFk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbeb29tvnW1PJhCFfm+LzRGf4rQH4h+mRD5WdfcOJip7bDhmpn9dWh/kDsA9nmyAw8lTVFdkNbb6rgFEjfCuuGRgsqgvhqMYF8ri/4R7ZodbOrQw4h+IeCst9JkYwQqznj+nvLr6yTHjkY0uxP2REV/lu8p4d5kZDrERof5B6R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGRoGnuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGRoGnuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54FAC116D0;
	Thu, 15 Jan 2026 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499602;
	bh=HcNBOjczZJtRy52hBXgJ3UgZx1Bo0j4GVsS6UHUyFk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGRoGnuoOjygNLyvwv1guubrm+wjHqu8vvLMLi8qSe7n2f9bTDLomEWMoW+k3XRjd
	 VprVz1U+xPmBIsBWM6M0fwUl879Ebyt0yPqQ9H4Z9eSM0/ICipRR+a/AMbN7QHkuuo
	 h6V/CCNCYeYjEEbj6v+MIJ+Sa8WSNFMJeM8cVJuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/451] net: dsa: b53: skip multicast entries for fdb_dump()
Date: Thu, 15 Jan 2026 17:48:06 +0100
Message-ID: <20260115164241.194208623@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit d42bce414d1c5c0b536758466a1f63ac358e613c ]

port_fdb_dump() is supposed to only add fdb entries, but we iterate over
the full ARL table, which also includes multicast entries.

So check if the entry is a multicast entry before passing it on to the
callback().

Additionally, the port of those entries is a bitmask, not a port number,
so any included entries would have even be for the wrong port.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251217205756.172123-1-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 416ed1ca1d52..b80e4216f98c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1761,6 +1761,9 @@ static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 	if (!ent->is_valid)
 		return 0;
 
+	if (is_multicast_ether_addr(ent->mac))
+		return 0;
+
 	if (port != ent->port)
 		return 0;
 
-- 
2.51.0



