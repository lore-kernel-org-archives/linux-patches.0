Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAD23EDE51;
	Tue, 12 May 2026 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609692; cv=none; b=HSDJFjddGDBtBp6LChVX4+VPt1BvQm3+2tlxEonjal5/ALyRtdD3uWvWAfzjhMr7OK2YlOP2XQb724cuVkRKkt4A8SZzrqoQLd0mGR4l33vVLU7zJL8I/WrYp4Kx1+9eniCUL61oAT8xs1xYdgvxU0FqQxZkN6Wypraz1E+0law=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609692; c=relaxed/simple;
	bh=9Ko/qEKfPuh/yIM+YrZa5404iRrzkpvgqU4YkBnTbfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9flYDMBqpbsLnACKyPtIowXn06g82q7oieO+sC8kb369wCWGq3KNJd30gH9M4Ju8rsc7dIy2gKsSiwCZRFpiCzRH+AlBw/4CA76I7y866oI4bhu3edN31kKI9ucAV7HjKb2mmodWFtj+QNGnpyC5Wv0CyE95wsNQf+pBj+HNDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIKZgIvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIKZgIvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008D9C2BCC7;
	Tue, 12 May 2026 18:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609692;
	bh=9Ko/qEKfPuh/yIM+YrZa5404iRrzkpvgqU4YkBnTbfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIKZgIvyBo2juIDIk8d5FuwyYA7Kqd36aqHD+ljX6qExeyopAvMzMCj1lbb/5maN/
	 z0cOcbWncek6MbTB0eb0flIKA/AK6Bj5ZWYQgBTOEGZINIGdiycwgys2h3M98l9ons
	 w62yyTZAy1CcALtAiBqm0ZuOtWRGRwWZWevOcFZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 253/307] mptcp: use MPTCP_RST_EMPTCP for ACK HMAC validation failure
Date: Tue, 12 May 2026 19:40:48 +0200
Message-ID: <20260512173945.466202269@linuxfoundation.org>
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

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

commit a6da02d4c00fdda2417e42ad2b762a9209e6cc49 upstream.

When HMAC validation fails on a received ACK + MP_JOIN in
subflow_syn_recv_sock(), the subflow is reset with reason
MPTCP_RST_EPROHIBIT ("Administratively prohibited"). This is
incorrect: HMAC validation failure is an MPTCP protocol-level
error, not an administrative policy denial.

The mirror site on the client, in subflow_finish_connect(), already
uses MPTCP_RST_EMPTCP ("MPTCP-specific error") for the same kind of
HMAC failure on the SYN/ACK + MP_JOIN. Use the same reason on the
server side for symmetry and accuracy.

Suggested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Fixes: 443041deb5ef ("mptcp: fix NULL pointer in can_accept_new_subflow")
Cc: stable@vger.kernel.org
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260501-net-mptcp-misc-fixes-7-1-rc3-v1-2-b70118df778e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -908,7 +908,7 @@ create_child:
 
 			if (!subflow_hmac_valid(subflow_req, &mp_opt)) {
 				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
-				subflow_add_reset_reason(skb, MPTCP_RST_EPROHIBIT);
+				subflow_add_reset_reason(skb, MPTCP_RST_EMPTCP);
 				goto dispose_child;
 			}
 


