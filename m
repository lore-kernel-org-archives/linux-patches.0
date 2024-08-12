Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FBE187325;
	Mon, 12 Aug 2024 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479102; cv=none; b=AJzNsd+Ub878/94AHnG0HIEhPk41cXYCNCQ7khyxX4UjMnpfS0Sr2+VyJjtrX9ZmLkY2kLU/8AI3DDU59EjI7JFuXNds4SCPmEh/Ap9dEf+Lp09A9xtP4z75EPPIJD7wLPcQvxSrCshlFz84tYHVi2LOX0Y8QFDyczVoR+xiz40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479102; c=relaxed/simple;
	bh=YCrfAsUf5NVO39TKAhId2XvpVaHQwewBn6toSrhEZos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEkyLUX7qoq/BiQDbQ0WoxOcKjHMk14CTSK2eoz0W+WbvwU43pRfkfaNU2Ash6gkvuVll1HMaLKeQZ9KtPGMNcPkq59/OxaoAxKnQ0ToDC+6X348QirAPJjjsfs0uzuWFyDxSQcp6b8aT7ULVFZJS+XRu8XkREIaN1zKVZIic6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKOrHtnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKOrHtnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783A6C32782;
	Mon, 12 Aug 2024 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479101;
	bh=YCrfAsUf5NVO39TKAhId2XvpVaHQwewBn6toSrhEZos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKOrHtnMM+VP99OLSZPTuVgnXKvukEI/5vbiuqejo8REKCFCv1AXI27rg91VqWN0d
	 g+LPNCF+KGTPkV94Tu3KUTZtI6jHDiIPANdtOTKn7wgvEDwQDXsMGkREgcZpbPmxyJ
	 FQyoMRRXwdIOezOGJwWmlCFbN0cmuV3vkYLj38Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 134/150] mptcp: pm: deny endp with signal + subflow + port
Date: Mon, 12 Aug 2024 18:03:35 +0200
Message-ID: <20240812160130.341851831@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 8af1f11865f259c882cce71d32f85ee9004e2660 upstream.

As mentioned in the 'Fixes' commit, the port flag is only supported by
the 'signal' flag, and not by the 'subflow' one. Then if both the
'signal' and 'subflow' flags are set, the problem is the same: the
feature cannot work with the 'subflow' flag.

Technically, if both the 'signal' and 'subflow' flags are set, it will
be possible to create the listening socket, but not to establish a
subflow using this source port. So better to explicitly deny it, not to
create some confusions because the expected behaviour is not possible.

Fixes: 09f12c3ab7a5 ("mptcp: allow to use port and non-signal in set_flags")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240731-upstream-net-20240731-mptcp-endp-subflow-signal-v1-2-c8a9b036493b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1360,8 +1360,8 @@ static int mptcp_nl_cmd_add_addr(struct
 	if (ret < 0)
 		return ret;
 
-	if (addr.addr.port && !(addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
-		GENL_SET_ERR_MSG(info, "flags must have signal when using port");
+	if (addr.addr.port && !address_use_port(&addr)) {
+		GENL_SET_ERR_MSG(info, "flags must have signal and not subflow when using port");
 		return -EINVAL;
 	}
 


