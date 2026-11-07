Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063394;
	b=p+w1nGgIzZkJHN1Y/0nd6rx8pgzQ+t1MwH2hsbkfkWB5UNkOAIl/lqXbFr5VO4j6QGeZ
	 9KtXhryo/eXR/CUnvvyLYBHQOtzR2ThajVTjUdxoS401SHRALeBwSEat+81oRqIxKhS3o
	 snRs3PMDL8YFL86yeFo72YGQswCxn5jioLOmszBF4x8CQVI0lvK4m8eA4P6gwsaz8b97D
	 cwmhNurrDHDHj40fcruHNmAHB2/3tk3J4pt3umdHfn/2KC/8KrOa/Jhis5cDa+9vuWqYR
	 tTU70YL534rysCbbZf9SMCGE8v52KaFeobXxUEe15z/Ef3SPudRFeSeoJZVJPjHsi0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=venoDySSttDYBBjNOh1JPOO5BXeou1IV4ef6gMk+z2I=;
	b=EjBaz48FI0Q/L+vXd75WqRbolzboNS2XkNtWr40Bgl03VEk6tVIPAQgJVMWI3snxpGWt
	 d8D0pAh/nfriHDbNMaYVR4ERznZ6xRtgKnEOROTx0N7WK7QV/wFQtgzKSynPWNf6uKgaI
	 /Th2Bzf5dwzycN3DHUrzZ+vloB9eLX9qKDLEy5e19K+MMxjRuQI2iAPLokUsZApupXdOV
	 53tUqr5R3KHlMS5GsK/I56/zji4VqhVnt4OIi7c43R90frJ/Cu6k/3dbybfq9gGJ/EbZz
	 86TpOU6FGaARdVVogvMjtloADDAuCIsJBaRUdHzTMf49b26vVIYiObYiQm6hwssOXwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C+vvTAh9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B08C606A333;
	Sat,  7 Nov 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C+vvTAh9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234371F0089F;
	Sat,  7 Nov 2026 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063394;
	bh=venoDySSttDYBBjNOh1JPOO5BXeou1IV4ef6gMk+z2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+vvTAh9ydigVESG1qdvNA07I+gKDFsJcjSlQ5j96Ns5UnWrFk2jTPHcRjlWzuNfd
	 rGMBaPjonvH2CMc1ICJ8fY4imFFTKWQkLW5S0kKARbLNZY2hR4wzCZflW21ewG5mHZ
	 7nJdotkOKRBArIB3W+Hk7npWhVyft4WeaYkzr+Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 567/869] Bluetooth: L2CAP: Reject mode changes on connected channels
Date: Sat,  7 Nov 2026 08:54:09 -0500
Message-ID: <20261107134912.492086465@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

[ Upstream commit c1398cf11b31a94c27ed810ba69515e0df5ce379 ]

A peer can send a configuration response with an RFC
option for another mode to a connected channel, for
example to switch it from Streaming to ERTM mode.
l2cap_parse_conf_rsp() then changes chan->mode, but
l2cap_ertm_init() is not called again, so the ERTM
sequence lists are never allocated. The next
out-of-sequence I-frame makes l2cap_seq_list_clear()
write through the NULL srej_list.list.

Refuse the channel when a response tries to change
the mode of a connected channel.

Fixes: f2fcfcd67025 ("Bluetooth: Add configuration support for ERTM and Streaming mode")
Cc: stable@vger.kernel.org
Closes: https://sashiko.dev/#/patchset/20261007144717.3832330-1-oss%40fourdim.xyz
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 462667a6e6ac2..4e1c21f05e54e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3801,7 +3801,11 @@ static int l2cap_parse_conf_rsp(struct l2cap_chan *chan, void *rsp, int len,
 		}
 	}
 
-	if (chan->mode == L2CAP_MODE_BASIC && chan->mode != rfc.mode)
+	/* A connected channel cannot change its mode, as the new mode would
+	 * not be initialized.
+	 */
+	if (chan->mode != rfc.mode &&
+	    (chan->mode == L2CAP_MODE_BASIC || chan->state == BT_CONNECTED))
 		return -ECONNREFUSED;
 
 	chan->mode = rfc.mode;
-- 
2.53.0



