Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052B11DF98B;
	Mon, 23 Jun 2025 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713246; cv=none; b=Zpch5xc0P2obD71xLg3SrBcOp4lPpEYX+TqyPcYSS/1nhDfM+i/Zyuxene0odJkjojXgba9vMjL3anK9Mo0ORYSTytRdkdF7v9RzwxreSnKf1ZY6pa3lY9RoxdWUmr+NWAJHkGBr3gEpUuE6+b9zKACAaacQZP6SE4W/Yx14NT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713246; c=relaxed/simple;
	bh=EGAoIC4cxviFCTBlzjOJIUGMbYJGcH7fCfTln7x3crw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYOxF6XoN82zZf+b9p+IKPuo0ZYsfWGDX+EOIvP0qjw5y58bn7lp0PbA9uMXLNxOz+G+3myxoNCOoqU35waf3589LTOov3KvqfKIHIhuXA71+vi9/LH11uSpUJ8kLOoCyOoBlNGk7teE4MHC9dLnmSttNNcjiO0kMKtX5hjM0oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/T2CXc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/T2CXc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9155AC4CEEA;
	Mon, 23 Jun 2025 21:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713245;
	bh=EGAoIC4cxviFCTBlzjOJIUGMbYJGcH7fCfTln7x3crw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/T2CXc74yScZvyPcCo55OsApHd7bGjJ44172hvMuYz2JpeYK0D6xlvCDFheHx/1c
	 BBJhmb7W/w05m52N3WrrQUaJoR2RVwX6IifhcPNdZYcFkCXdTqcMn+X4S8l8js7Nnu
	 Mxq2yR4asWLYB93TiZBEw7EvGwp6K2Y4GuecAoO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.12 034/414] NFSv4: Dont check for OPEN feature support in v4.1
Date: Mon, 23 Jun 2025 15:02:51 +0200
Message-ID: <20250623130642.880185018@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit 4d4832ed13ff505fe0371544b4773e79be2bb964 upstream.

fattr4_open_arguments is a v4.2 recommended attribute, so we shouldn't
be sending it to v4.1 servers.

Fixes: cb78f9b7d0c0 ("nfs: fix the fetch of FATTR4_OPEN_ARGUMENTS")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3957,8 +3957,9 @@ static int _nfs4_server_capabilities(str
 		     FATTR4_WORD0_CASE_INSENSITIVE |
 		     FATTR4_WORD0_CASE_PRESERVING;
 	if (minorversion)
-		bitmask[2] = FATTR4_WORD2_SUPPATTR_EXCLCREAT |
-			     FATTR4_WORD2_OPEN_ARGUMENTS;
+		bitmask[2] = FATTR4_WORD2_SUPPATTR_EXCLCREAT;
+	if (minorversion > 1)
+		bitmask[2] |= FATTR4_WORD2_OPEN_ARGUMENTS;
 
 	status = nfs4_call_sync(server->client, server, &msg, &args.seq_args, &res.seq_res, 0);
 	if (status == 0) {


