Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C291534FB;
	Mon, 16 Sep 2024 12:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488464; cv=none; b=ZR4ZMkmuxEgyCbRx0iOSlMmHwBpLAx2ioV+wmcJZYmUdNuF6bga3GpuQ3GFAPNsAXuINLYIj0pI8DZjkN9zqv43BMpAaI0BpNZrfkq75Uf+7+vrIoPluFwn4lBLqOcaXDlKKNwWMWTGwk9PRSZc9x8sCFzUGYToDt0b5o+Nc8gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488464; c=relaxed/simple;
	bh=WWpN15rnZvg/HzHcLYhvpG7uRvisTjnVGAiETzsZ+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQbp4GW/A68Eamn12ZSvh9aMJmt34WtprDhumEUGBzsp6/SvxRopMzrBlMXzV7Ql2ODgvfftYKRBvFoo8efAPnQvsHO8z55dexPxUg/ecZIdlEb2rmdJgUC39VoWdenbfqthh1Jo1aR1vPUMIjSJJQNy4YuS4La+Xt+wP8lu7FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeQa/GQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeQa/GQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5058C4CEC4;
	Mon, 16 Sep 2024 12:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488464;
	bh=WWpN15rnZvg/HzHcLYhvpG7uRvisTjnVGAiETzsZ+wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeQa/GQJlMygRgthpXgkzcpue79tsXyqYoM5cddrt66UB23ohOwLDAz8xLNJ3qL8T
	 Kibx77YZMcMApzfK0V59RCD+guGRTYFdXkKHR/GzVBp6RAFGqminYUHcaWD7LCrkRL
	 FH16bBbWCDHM+bGo1jq+Cpy/nYB7GjUD87hDomHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Davide Caratti <dcaratti@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 096/121] netlink: specs: mptcp: fix port endianness
Date: Mon, 16 Sep 2024 13:44:30 +0200
Message-ID: <20240916114232.301341597@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 09a45a5553792bbf20beba0a1ac90b4692324d06 ]

The MPTCP port attribute is in host endianness, but was documented
as big-endian in the ynl specification.

Below are two examples from net/mptcp/pm_netlink.c showing that the
attribute is converted to/from host endianness for use with netlink.

Import from netlink:
  addr->port = htons(nla_get_u16(tb[MPTCP_PM_ADDR_ATTR_PORT]))

Export to netlink:
  nla_put_u16(skb, MPTCP_PM_ADDR_ATTR_PORT, ntohs(addr->port))

Where addr->port is defined as __be16.

No functional change intended.

Fixes: bc8aeb2045e2 ("Documentation: netlink: add a YAML spec for mptcp")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240911091003.1112179-1-ast@fiberby.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/mptcp_pm.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/netlink/specs/mptcp_pm.yaml b/Documentation/netlink/specs/mptcp_pm.yaml
index af525ed29792..30d8342cacc8 100644
--- a/Documentation/netlink/specs/mptcp_pm.yaml
+++ b/Documentation/netlink/specs/mptcp_pm.yaml
@@ -109,7 +109,6 @@ attribute-sets:
       -
         name: port
         type: u16
-        byte-order: big-endian
       -
         name: flags
         type: u32
-- 
2.43.0



