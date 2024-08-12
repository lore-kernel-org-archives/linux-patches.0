Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEB7183CA6;
	Mon, 12 Aug 2024 16:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479713; cv=none; b=LgV5zxgAZFR+/qiruGXUMH2iFicg+Kvy36q6rd0FsWlxzrB2ZOVnqdxiXF6fpKfe4nCiSgSsxgvPZveFLk9M1BufMbTvj+B5+KQy2df3qZ4JxLCJolGQVrRmn7uAYJGM8vshQuhjcJmOr8yIXFp4kX9JgTEdOpZbRmtv/GzPJbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479713; c=relaxed/simple;
	bh=tM4XvpW+hgZrfwWEEl6AnA8ZoTaASyyDxrS2I2SGCiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hd5bFYneskY6rh3RrplSD8WXSWBdP5i1Vf6hhoH24BJGVZqQvCtnM0r4zmkkGDPZToeWtuPZqvVS8ZBIpeV0ljWN5yJ+eOAzHMup9yUqbVE7Sa2WXN/wztCa9EaUQJDuy0jtCizZmnI9SgBEWoBMG1rBZFspbAM88bFuxJud9u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDOc7/ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDOc7/ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB45FC32782;
	Mon, 12 Aug 2024 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479712;
	bh=tM4XvpW+hgZrfwWEEl6AnA8ZoTaASyyDxrS2I2SGCiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDOc7/otDwOk2x3SPw7GQI4TRD0fmjQLXpOKsmGlOHktIW+gmtGdZR4CcxgRDD/Il
	 4EGj2Sr9vcQcYdbLxwqpHTdRBmmxQWallTxE577LDRikTTj/zTwyrNVM61PVOHEuA3
	 2h3FjDFeDbAEEugSIXgbC0j+sgX5u9pKwSoVrTjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 170/189] mptcp: pm: deny endp with signal + subflow + port
Date: Mon, 12 Aug 2024 18:03:46 +0200
Message-ID: <20240812160138.689706851@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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
@@ -1359,8 +1359,8 @@ static int mptcp_nl_cmd_add_addr(struct
 	if (ret < 0)
 		return ret;
 
-	if (addr.addr.port && !(addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
-		GENL_SET_ERR_MSG(info, "flags must have signal when using port");
+	if (addr.addr.port && !address_use_port(&addr)) {
+		GENL_SET_ERR_MSG(info, "flags must have signal and not subflow when using port");
 		return -EINVAL;
 	}
 


