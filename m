Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11D022094;
	Tue, 22 Jul 2025 14:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193282; cv=none; b=cUPsuSVC0MhArbG8YW2fQ62tyNiQLXXGuX2RImTfAHDm9XeotoAPbPP2h9GnhtWdLJE1QhTnAQL6ghkGydkta3yKQZq42NXM8aJYC4qyAmo1syuzuT0cWoNqfUxcYiy08Q8OMTemGgym7zuT0kdI0Pe0o0NswlAq1mvmm2Ip6CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193282; c=relaxed/simple;
	bh=67t/T/tL+wj4pF6eKrTNMY7Wigayhcmjb+NPiMv3o3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V72N3UaFddO3GQedU2b7vdSV0Kx276Qnn2Pp0Pkj1qg0iUsj0p4zUQZWITY42ZbfQahxuaL6h9GQ5A1sGJ3a/qnTQMti+WkHy+b4KeIzGt/4vHGtD1ez003XWVrVyHQnieSWUdd3SZH7I9eQTaWvO+0bbaDLxZSYKCOxS6+d10c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re7q7mFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re7q7mFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E0FC4CEF1;
	Tue, 22 Jul 2025 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193282;
	bh=67t/T/tL+wj4pF6eKrTNMY7Wigayhcmjb+NPiMv3o3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Re7q7mFCRk7P+iJeNME6Ve3BjHKGVPTqLpJywHX3jLObhUrehlIlLrkQvz0QdT0MG
	 fB/soo8TrGTbjRdXAWyBWtE0Ro3CmOuqQniEiFwFi9Q0SvVzRxlS59Djegoe1Klfju
	 loVD1P9RhpJFlYTW8WNmH+mgfvv8mewGHyZNSo+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 046/187] mptcp: reset fallback status gracefully at disconnect() time
Date: Tue, 22 Jul 2025 15:43:36 +0200
Message-ID: <20250722134347.468164942@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit da9b2fc7b73d147d88abe1922de5ab72d72d7756 upstream.

mptcp_disconnect() clears the fallback bit unconditionally, without
touching the associated flags.

The bit clear is safe, as no fallback operation can race with that --
all subflow are already in TCP_CLOSE status thanks to the previous
FASTCLOSE -- but we need to consistently reset all the fallback related
status.

Also acquire the relevant lock, to avoid fouling static analyzers.

Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250714-net-mptcp-fallback-races-v1-3-391aff963322@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3140,7 +3140,16 @@ static int mptcp_disconnect(struct sock
 	 * subflow
 	 */
 	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
+
+	/* The first subflow is already in TCP_CLOSE status, the following
+	 * can't overlap with a fallback anymore
+	 */
+	spin_lock_bh(&msk->fallback_lock);
+	msk->allow_subflows = true;
+	msk->allow_infinite_fallback = true;
 	WRITE_ONCE(msk->flags, 0);
+	spin_unlock_bh(&msk->fallback_lock);
+
 	msk->cb_flags = 0;
 	msk->recovery = false;
 	WRITE_ONCE(msk->can_ack, false);


