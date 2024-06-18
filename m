Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF211A00F5;
	Tue, 18 Jun 2024 13:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716144; cv=none; b=gXECI3uAF0+IPOEZ3GTwZapTRkNoXUFXSuBVMIm2DXzt4u/3b2xRtEZ30XwDFcSj6nLHMD5VHYlzQP4QYjhiIO82O1crpBQ+frsDVtfgO62qfpU3XKKFIggnphEQYZ1bCyyIKOJaIHEqptAHV/GvHq4LkwzbYq1a+eOBx2YhrzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716144; c=relaxed/simple;
	bh=GVT6TofnXvYbb7uMw+39U7OIhmNpg0hyIemw8bYqlow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgp01wjPcduCSAnZeq69064GrMwFCI9mAD3vyNzHFOf5CAMoPnNx9si+7/4bGmUW8wSNrVVvJObYyVS9nCPoMUa3jEPVXVRaFk0AtW8nMej0FbZw18eaWIOYUQD8S8owrQYx0mLi7g46dY9tfZO/FmrhNgGpGO2NyrfatNI6e3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OT6bn0uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OT6bn0uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E938C3277B;
	Tue, 18 Jun 2024 13:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716144;
	bh=GVT6TofnXvYbb7uMw+39U7OIhmNpg0hyIemw8bYqlow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT6bn0uyDjIVrkMtggXwx4M3uZUudb6SiDj2gGdVkDq+Fpgt4zUyYaDAKE/WW3o87
	 AoA3mJRXvSWTgvQghJB+Y1QZrbTdFH+BlMn7DU1sFTRQpp4bZ7DZjuImUY+bXDxlQW
	 wm26sLPyNwRiA4qCagGDNapIy3EqXaZV141xACqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 516/770] NFSD: Show state of courtesy client in client info
Date: Tue, 18 Jun 2024 14:36:09 +0200
Message-ID: <20240618123427.232297539@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit e9488d5ae13c0a72223c507e2508dc2ac66cad4f ]

Update client_info_show to show state of courtesy client
and seconds since last renew.

Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6851fece3a760..9116496b476aa 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2494,10 +2494,17 @@ static int client_info_show(struct seq_file *m, void *v)
 	memcpy(&clid, &clp->cl_clientid, sizeof(clid));
 	seq_printf(m, "clientid: 0x%llx\n", clid);
 	seq_printf(m, "address: \"%pISpc\"\n", (struct sockaddr *)&clp->cl_addr);
-	if (test_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags))
+
+	if (clp->cl_state == NFSD4_COURTESY)
+		seq_puts(m, "status: courtesy\n");
+	else if (clp->cl_state == NFSD4_EXPIRABLE)
+		seq_puts(m, "status: expirable\n");
+	else if (test_bit(NFSD4_CLIENT_CONFIRMED, &clp->cl_flags))
 		seq_puts(m, "status: confirmed\n");
 	else
 		seq_puts(m, "status: unconfirmed\n");
+	seq_printf(m, "seconds from last renew: %lld\n",
+		ktime_get_boottime_seconds() - clp->cl_time);
 	seq_printf(m, "name: ");
 	seq_quote_mem(m, clp->cl_name.data, clp->cl_name.len);
 	seq_printf(m, "\nminor version: %d\n", clp->cl_minorversion);
-- 
2.43.0



