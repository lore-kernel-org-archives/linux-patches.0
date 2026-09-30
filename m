Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E85850AC0D;
	Wed, 30 Sep 2026 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787962; cv=none; b=iR4tgEiV255T40gFPRMm23F4nxs0fzzmLUIVwMsExp1I6Suy6H6Bv1nzC23qIKYbxlJivAIUH2NP+WeEhFdoFMApjcgeJ5lbMXhfAJU7FJZoy0IaFtymd5115rlzhf1hcdE+9QTNvVUu7BXhUxBVNwTO57yMvWwv4riDbYZQ22g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787962; c=relaxed/simple;
	bh=EDU1kY/OKxrOphiLgt5vNQ18k2yHDFAbHb2ZqO/v3Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThLgxSv4MHKfvsANAGg69mrSUdSGGeCre0yMCPqZRZm6p5PZvqrBU8KG7LUBt0o4PeYKANbnxDZiJ2Sl0MlslTQjNN0d5n+0Fy8YKSzK0dbs0xmFrGiaPDJdiDmKfPzcx2wlZdhLeDs2bwkMhy+vYtFJqfTPN7UdPLsaNZYdCkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bt/q4pQP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bt/q4pQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037A41F000FF;
	Wed, 30 Sep 2026 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787961;
	bh=hjGhcJ8B3cOeBWZ14HpxOxeQ5ratYpdL75PIryq/f0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bt/q4pQPnBrtgK1CJmxkyrW2qEhZQhg+hJoz7zQizmUV3FZrWiOFIaR46cfvjB8DG
	 vWrs6mpR23WGDvMMeODt9ooXF7KTiZ5TrGmwp4JVnogVwDFPCHt2sMzl6YLpPnNYAj
	 ETNCcuiwOMURnEcLTibI1coqjip+IesriHyYRrIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com,
	Adarsh Das <adarshdas950@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 415/457] smb: client: delete compound mids on send failure before unlock
Date: Wed, 30 Sep 2026 17:28:40 +0200
Message-ID: <20260930152354.940384169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adarsh Das <adarshdas950@gmail.com>

commit 8f6f8a48399f82f4a83f7b9f25b9707e0062a4f9 upstream.

When sending a compound request fails, smb_send_rqst() kicks off a
reconnect. compound_send_recv() still has those mids on pending_mid_q,
but it unlocks the server without removing them first.

During reconnect, cifs_abort_connection() walks pending_mid_q and runs
each mid callback. With no response yet, those callbacks return credits
and drop in_flight. Then compound_send_recv()'s send-error path returns
the same credits again. in_flight ends up decremented twice and
smb2_add_credits() WARNs.

syzbot hits this during SMB2_negotiate when the socket send fails.

cifs_call_async() already calls delete_mid() before unlock on send
failure. Do the same for compound chains and set cancelled_mid[] so the
out: path does not delete them again.

Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
Reported-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a727d22.40259c87.584f4.04ce.GAE@google.com
Tested-by: syzbot+eeb58d2197d88720a228@syzkaller.appspotmail.com
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Adarsh Das <adarshdas950@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/transport.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -978,6 +978,10 @@ compound_send_recv(const unsigned int xi
 	if (rc < 0) {
 		revert_current_mid(server, num_rqst);
 		server->sequence_number -= 2;
+		for (i = 0; i < num_rqst; i++) {
+			delete_mid(server, mid[i]);
+			cancelled_mid[i] = true;
+		}
 	}
 
 	cifs_server_unlock(server);


