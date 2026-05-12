Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9863D36A378;
	Tue, 12 May 2026 18:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609697; cv=none; b=gy08uaHOMbkS5BA5/nQE22+GMl23ju6mhJLq+46ik6k//svc01kCW0RsnpxA1cAs7jHGh1zYXXJyqAS/nQ7ga+ipEaqU/6a1j2FB5LJtplpesHZ7ATKjxFKuKOeog7s62VDhD7h/J2CNXSikCwDnz4Sk/jieoaO/ECFIynyGJM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609697; c=relaxed/simple;
	bh=DaxzpXWFaTXdBHKNnmpzZxzQvS2OznJGnwgJx4C8g2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXh7ZvpoTa5uIq1krZ3LC+TDl0vRyidHjgEsrcjR5Rr5cjMEwBYF+KxXNMm1b6ACj7XmBWPAdbxG8j68jXKCogusIBKzzJxB0O/8nGqV8Ls+VZ9qRHisov3oHNbk9P3teH1GKY7kGBfY9L18Lae4OQDJomu8h2BledSDsCQ8VPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtSlAl56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtSlAl56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281D3C2BCB0;
	Tue, 12 May 2026 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609697;
	bh=DaxzpXWFaTXdBHKNnmpzZxzQvS2OznJGnwgJx4C8g2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtSlAl56MlytEsd50jaQbMJjo2dpDLAkRoe+vvZZ6UN3AupJnCQ5odYJtcXx4cTgG
	 A+o8UiGF0QI48qvcHcinPxKqurm2zAs9MAMmagx5sI163uTRWVpKUAqCbgK0fyiSAM
	 yCPSJvBnSmeMNPTKEbxFj8EePwibDsM3hKMmHuKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 255/307] mptcp: sockopt: increase seq in mptcp_setsockopt_all_sf
Date: Tue, 12 May 2026 19:40:50 +0200
Message-ID: <20260512173945.508274717@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 70ece9d7021c54cf40c72b31b066e9088f5f75f5 upstream.

mptcp_setsockopt_all_sf() was missing a call to sockopt_seq_inc(). This
is required not to cause missing synchronization for newer subflows
created later on.

This helper is called each time a socket option is set on subflows, and
future ones will need to inherit this option after their creation.

Fixes: 51c5fd09e1b4 ("mptcp: add TCP_MAXSEG sockopt support")
Cc: stable@vger.kernel.org
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260501-net-mptcp-misc-fixes-7-1-rc3-v1-4-b70118df778e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -812,6 +812,10 @@ static int mptcp_setsockopt_all_sf(struc
 		if (ret)
 			break;
 	}
+
+	if (!ret)
+		sockopt_seq_inc(msk);
+
 	return ret;
 }
 


