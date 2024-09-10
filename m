Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEBD1922F6;
	Tue, 10 Sep 2024 10:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963887; cv=none; b=amqltmOGR5gVwvXBe1KTTOo9971wr2A5Q3ZAK/y2INAhwOZxpa4iUARTxbDymV/DxoEVmWuzEhi95LmZqpHeLyjMVQ5QupMvuu89KDkKCk2AChNpX7eRCt56Uxf3y+LL+cAd3zEWva31Y9TJpCrMZMGZiqYJn2hV8TeaPl4Je74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963887; c=relaxed/simple;
	bh=YuSnyHu9AdsyBSa2CMSzK+jZhmOaPo2gkPu7MRHnD0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSQjdmBJY74amVNfhsjiVU/VvN4yZ7HmXp0J6rlPgRGkHeCsKtM067+dI0+N93nYjOvIYweTIOkJPamGhIIqg/cQdZKY23Z33XT37cRKvMDdCwpH8671kOAcBHy1/s7PJzb0g1L7uOZP/6SGhg0XIpnIIcCy4AhmGvS8lAw/FF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvDXFFmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvDXFFmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C84C4CEC3;
	Tue, 10 Sep 2024 10:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963887;
	bh=YuSnyHu9AdsyBSa2CMSzK+jZhmOaPo2gkPu7MRHnD0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvDXFFmrd4wa3KlqtgoxBQ36d/chwUX6kdzGWtYCgTmbjIXiwLYxnmWLY+LrDqxcL
	 mvCWctZqXq5iSOoEUso8EfB+ZGBixYjqiwaN1fpQGNsU3MqAAdR2HkkRtESsZkblj7
	 zqV928amAwKK/VPxtROkQuBC91BzhgSpvmu+UG0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lex Siegel <usiegl00@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Neil Brown <neilb@suse.de>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 5.15 211/214] net, sunrpc: Remap EPERM in case of connection failure in xs_tcp_setup_socket
Date: Tue, 10 Sep 2024 11:33:53 +0200
Message-ID: <20240910092607.116325048@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit 626dfed5fa3bfb41e0dffd796032b555b69f9cde upstream.

When using a BPF program on kernel_connect(), the call can return -EPERM. This
causes xs_tcp_setup_socket() to loop forever, filling up the syslog and causing
the kernel to potentially freeze up.

Neil suggested:

  This will propagate -EPERM up into other layers which might not be ready
  to handle it. It might be safer to map EPERM to an error we would be more
  likely to expect from the network system - such as ECONNREFUSED or ENETDOWN.

ECONNREFUSED as error seems reasonable. For programs setting a different error
can be out of reach (see handling in 4fbac77d2d09) in particular on kernels
which do not have f10d05966196 ("bpf: Make BPF_PROG_RUN_ARRAY return -err
instead of allow boolean"), thus given that it is better to simply remap for
consistent behavior. UDP does handle EPERM in xs_udp_send_request().

Fixes: d74bad4e74ee ("bpf: Hooks for sys_connect")
Fixes: 4fbac77d2d09 ("bpf: Hooks for sys_bind")
Co-developed-by: Lex Siegel <usiegl00@gmail.com>
Signed-off-by: Lex Siegel <usiegl00@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>
Link: https://github.com/cilium/cilium/issues/33395
Link: https://lore.kernel.org/bpf/171374175513.12877.8993642908082014881@noble.neil.brown.name
Link: https://patch.msgid.link/9069ec1d59e4b2129fc23433349fd5580ad43921.1720075070.git.daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtsock.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2335,6 +2335,13 @@ static void xs_tcp_setup_socket(struct w
 	case -EALREADY:
 		xprt_unlock_connect(xprt, transport);
 		return;
+	case -EPERM:
+		/* Happens, for instance, if a BPF program is preventing
+		 * the connect. Remap the error so upper layers can better
+		 * deal with it.
+		 */
+		status = -ECONNREFUSED;
+		fallthrough;
 	case -EINVAL:
 		/* Happens, for instance, if the user specified a link
 		 * local IPv6 address without a scope-id.


