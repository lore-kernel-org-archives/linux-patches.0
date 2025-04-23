Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04270283687;
	Wed, 23 Apr 2025 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421624; cv=none; b=GvxMhjyJAIgs+HjE2UCds4Ouf/NWdD9Cz5g7GhWoVo28OP7TSaCq4v5bud69bbwlBBsZdsVzU1ci04V3SYC3BY3RI3EIVHOeBCJDR36dFzbcWy8Go90/eWD3mQuGden7tcylVGX4B09cwUA/K3aGoYy/SGNtaD6MJP51YvcT8c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421624; c=relaxed/simple;
	bh=Z+26j0WzcyPKEdiAYsBAMMzmij1hPWPZF98lu0Y3e2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8FKU96AY4ogA/rLwy6rdaE21e2XDOw6aPeHnZ0grVFlp6FevFSYWc6TIAsyRxUOz6yYqscD/SilfbWbvXKzCq61On6cYeJOf3J4Elzwg9ToE3B4Hj+qWSoM2CoY3EuEux64aOewUgivMMMo5ToOwxD+AMwXkDOsRlHMbLzJ2oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWUt7cKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWUt7cKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C386C4CEE2;
	Wed, 23 Apr 2025 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421623;
	bh=Z+26j0WzcyPKEdiAYsBAMMzmij1hPWPZF98lu0Y3e2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWUt7cKvutS0oE5LZYXBICVOB9x5DLVA/IY/0dQZEdmlOn63Vik47+5JmtdQ3GlVf
	 z1funhir5dgiK6pK5jjwjn9TZ7G2EzoUfTJS4+vn0s6t6DPuF+WDpfciK+EnAjAXRY
	 L5cAHfg3AOzeYQ7d1T6FF+IFkb15cEWKgujQ9klM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Liu <liucong2@kylinos.cn>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 159/291] selftests: mptcp: close fd_in before returning in main_loop
Date: Wed, 23 Apr 2025 16:42:28 +0200
Message-ID: <20250423142630.888642467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit c183165f87a486d5879f782c05a23c179c3794ab upstream.

The file descriptor 'fd_in' is opened when cfg_input is configured, but
not closed in main_loop(), this patch fixes it.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Co-developed-by: Cong Liu <liucong2@kylinos.cn>
Signed-off-by: Cong Liu <liucong2@kylinos.cn>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250328-net-mptcp-misc-fixes-6-15-v1-3-34161a482a7f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1213,7 +1213,7 @@ again:
 	/* close the client socket open only if we are not going to reconnect */
 	ret = copyfd_io(fd_in, fd, 1, 0);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (cfg_truncate > 0) {
 		shutdown(fd, SHUT_WR);
@@ -1233,7 +1233,10 @@ again:
 		close(fd);
 	}
 
-	return 0;
+out:
+	if (cfg_input)
+		close(fd_in);
+	return ret;
 }
 
 int parse_proto(const char *proto)


