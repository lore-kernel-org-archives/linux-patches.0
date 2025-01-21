Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AA6E571;
	Tue, 21 Jan 2025 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482571; cv=none; b=g1W/C84VpqtdCQOoiKk23BtadJhq5DfYCed5881hU7tdkSZwY0yaspCxruncsekZWv/8Yq7+CyEzYo9Z2Hz+ZD4qGafmmX09ycY8fwT8d4gk6N+tnTC3APXKbkhOUQRGCLx0GjrFxcZGU8/cXG5yCdKR8jmCLDGfQSqBTIN/wGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482571; c=relaxed/simple;
	bh=c0EvetZpJEePMr4juIsAAkpoyWAsadgNFVzZ2Xd90ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2eQly27blYOTKRaKbSaTVT2bs7h3+V+6S7feT4K7VAzPcxi8tx9m7Qisw6oOBcN1YLHQuasV8EMloVpiY2C7d8razc2vx/DH6ggPmX2oRzX+VsbbfUXYlFEylAGZZVGe41h17lyfOFyTpBa/0Mx8EUBbti9uyoEM26Y9J7/EtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFBi7bXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFBi7bXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0A0C4CEDF;
	Tue, 21 Jan 2025 18:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482571;
	bh=c0EvetZpJEePMr4juIsAAkpoyWAsadgNFVzZ2Xd90ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFBi7bXWO4/duqksF2L7XlkUvKfOuxoFy63Fi1Tz3jMzaAV3MvTRe1IZEoGd5JOz3
	 M0c7b7ZJtzvEKmObf58MbwO+9L6IZgne//4zLnakCvcM0stAaGF1gJ/DWPTyfbBmlv
	 Pg82tr546Q8VpyV7blGhVNdS7g1yewp/7FVf4pNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Paul Kramme <kramme@digitalmanufaktur.com>
Subject: [PATCH 6.12 122/122] apparmor: allocate xmatch for nullpdb inside aa_alloc_null
Date: Tue, 21 Jan 2025 18:52:50 +0100
Message-ID: <20250121174537.764233969@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Ryan Lee <ryan.lee@canonical.com>

commit 17d0d04f3c999e7784648bad70ce1766c3b49d69 upstream.

attach->xmatch was not set when allocating a null profile, which is used in
complain mode to allocate a learning profile. This was causing downstream
failures in find_attach, which expected a valid xmatch but did not find
one under a certain sequence of profile transitions in complain mode.

This patch ensures the xmatch is set up properly for null profiles.

Signed-off-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Cc: Paul Kramme <kramme@digitalmanufaktur.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -626,6 +626,7 @@ struct aa_profile *aa_alloc_null(struct
 
 	/* TODO: ideally we should inherit abi from parent */
 	profile->label.flags |= FLAG_NULL;
+	profile->attach.xmatch = aa_get_pdb(nullpdb);
 	rules = list_first_entry(&profile->rules, typeof(*rules), list);
 	rules->file = aa_get_pdb(nullpdb);
 	rules->policy = aa_get_pdb(nullpdb);


