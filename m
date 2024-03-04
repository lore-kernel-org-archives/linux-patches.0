Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220978F58;
	Mon,  4 Mar 2024 21:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588500; cv=none; b=NQ81yHcSnRakHWzrk/LTZgpQj6YyQpSjn06tX/InKNPEPMpEAi+WphfjvCFmZ88horpO5M1KwizeKeF5L2166RPxCRoBjautMbmWTZOAa8d62vdH8FNkg1Yylg3rPforU6gyGe04VuFIPt/4eUhh6YHumuoZfvJYMaRbBr6auEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588500; c=relaxed/simple;
	bh=dgnLT9nsXYaOXkf5Hb23qCGmqEOV11OhoNTbdSJbzI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnJAhuAVwaHqo9WuEIvpW+OQNeGV1oPstO5zxkoUXfI+5xN6H3Tbg6GDUZ0khys/s7ME1LWIhgSD8oIagSL12jA/bDNgpA+tO63jo3X0EdwOI4AY8GALwJMvm3wCnJOOEHHB8/MyCbLZWztRLcFF4AEaKmpo8CEVpKpmMsQLJnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DieGuiZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DieGuiZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9251C433F1;
	Mon,  4 Mar 2024 21:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588500;
	bh=dgnLT9nsXYaOXkf5Hb23qCGmqEOV11OhoNTbdSJbzI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DieGuiZw8avPlt1XAOOOBtys6LliUxa4yeyNBEf0OJsUM71hcqiCvW5HeRBHgbLkK
	 HWVZY2Lbd38fSBJdQhmYLH1Is2xcg5tOYWz24WNIhL2yMZ0ON2IffealZlFZJO0pY4
	 XJvpxcTa54nv9OfLQM2+TOfyeTDa9V/X+QyUVWHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 107/143] mptcp: avoid printing warning once on client side
Date: Mon,  4 Mar 2024 21:23:47 +0000
Message-ID: <20240304211553.336534889@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 5b49c41ac8f27aa3a63a1712b1f54f91015c18f2 upstream.

After the 'Fixes' commit mentioned below, the client side might print
the following warning once when a subflow is fully established at the
reception of any valid additional ack:

  MPTCP: bogus mpc option on established client sk

That's a normal situation, and no warning should be printed for that. We
can then skip the check when the label is used.

Fixes: e4a0fa47e816 ("mptcp: corner case locking for rx path fields initialization")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-3-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -981,10 +981,10 @@ static bool check_fully_established(stru
 	if (mp_opt->deny_join_id0)
 		WRITE_ONCE(msk->pm.remote_deny_join_id0, true);
 
-set_fully_established:
 	if (unlikely(!READ_ONCE(msk->pm.server_side)))
 		pr_warn_once("bogus mpc option on established client sk");
 
+set_fully_established:
 	mptcp_data_lock((struct sock *)msk);
 	__mptcp_subflow_fully_established(msk, subflow, mp_opt);
 	mptcp_data_unlock((struct sock *)msk);


