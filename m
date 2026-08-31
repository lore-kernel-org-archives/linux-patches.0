Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3294050DDCE;
	Mon, 31 Aug 2026 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183770; cv=none; b=kWbxtBNQGlWQ7TulbzYG6hiYOWcbtnGf6grK1YycuEWp5ea9ekH3Rt7nCmMe7LWaoCZuhiq96WItg9LMKYtRSB4UlGkGZEPW3EILq6pwFPdnNhPLc5EJdMnFheoSoU2kbpsgH7pEKQJkQT5F377HN5gOz4MJl7hAGxwA7AMMzE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183770; c=relaxed/simple;
	bh=WuywI0plRZ9xsGn1Oae2F7AbdmlPKmIl9F9O/xUD/RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtwEhLtl7WjCADF+kqBesAdzfgN7HycF4FWFh85ydkmiKtyt6r+KQUFPIZu9CvB5m/4llW2ZRRc3R9HRQvZ/I2qX2cPFy6af+l2q8QrTOWG5ziMu+iprgmCtgH20NXpVka8TFsbYI80dag5U+GUIpoTOzbfNeOrESPGfEiwkSiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/zDxOwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/zDxOwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883641F00A3F;
	Mon, 31 Aug 2026 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183768;
	bh=U83ms0ko2w2l/C3R+IGQ8qF3criNxj0g/0Ohx7VMVEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/zDxOwTtstbfmPZUTREDlhWlIn/Vw3Qp2+1tiD6vPNWGYIRoeWXu5fSWQdu/+goj
	 8Da1zrRulb239VtA2eu3aYjy5aK2QKXC4n6ak0RdCjP9d9y5zzQ0065G50/2wxNzhr
	 hw/NAdZsgK208vi64rFr0mX+/XVSw3GWT8gYOwGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rastislav Szabo <rastislav.szabo@isovalent.com>,
	David Ahern <dsahern@kernel.org>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 36/76] net/tcp: fix TCP-AO key deletion in VRFs
Date: Mon, 31 Aug 2026 15:34:08 +0200
Message-ID: <20260831133401.286378902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rastislav Szabo <rastislav.szabo@isovalent.com>

commit 94ad9e114a1c7b16ea418c1456ac3835e038ab3f upstream.

TCP-AO keys with TCP_AO_KEYF_IFINDEX store the VRF L3 interface index in
l3index. tcp_ao_del_cmd() validates the supplied ifindex, but does not
assign it to its local l3index before matching keys.

As a result, deleting a key scoped to a non-default VRF always fails with
ENOENT because it is matched against l3index 0.

Fixes: 248411b8cb89 ("net/tcp: Wire up l3index to TCP-AO")
Cc: stable@vger.kernel.org
Signed-off-by: Rastislav Szabo <rastislav.szabo@isovalent.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260822201119.272269-1-rastislav.szabo@isovalent.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1854,6 +1854,9 @@ static int tcp_ao_del_cmd(struct sock *s
 	if (cmd.ifindex && !(cmd.keyflags & TCP_AO_KEYF_IFINDEX))
 		return -EINVAL;
 
+	if (cmd.keyflags & TCP_AO_KEYF_IFINDEX)
+		l3index = cmd.ifindex;
+
 	ao_info = setsockopt_ao_info(sk);
 	if (IS_ERR(ao_info))
 		return PTR_ERR(ao_info);


