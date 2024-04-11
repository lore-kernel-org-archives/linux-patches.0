Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD156BB29;
	Thu, 11 Apr 2024 10:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832334; cv=none; b=Sgxz6voh/anjmw9U31fx6Pp/N93dAj3kL9A4vuloigjWPCJRKkKLKQ+cZSBaargHNaf0CP5Za38TrX40lSMA1an2DHCJkwxxZ8K/VcZgmlYkZmPEbUt/3wWrsziWeF3zM+gW5mb+csDaawNwdcitlssUjjIV6mwt+VvwplmJCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832334; c=relaxed/simple;
	bh=Ru6XtzkjUIoGo4aB0nx2WjnuegwOOh25p6xw3YpnBs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJuDrbpWLx7BZ61PBveuo0y2HPq8E8mOq9a2UPUSeYEwcsEDcOWu2+8wmxHDH9rUjwj5ms7YrceiUGcsob+xDD+I+vB4WZgDKs/oADvae2otXQbRN5YchLiJT59qfcdtSt3cg794SwxT/lX63wHD9vOXOsmDzbKn4JNiMLY6/rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hw7jkL9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hw7jkL9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5421CC433C7;
	Thu, 11 Apr 2024 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832333;
	bh=Ru6XtzkjUIoGo4aB0nx2WjnuegwOOh25p6xw3YpnBs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hw7jkL9pdkvmv0GhFKPH+5LionID4spd6KUL5glCI1moQljOFgi5DFmee3/rxpdHQ
	 JQ0J5yGK9roJyqm6hXGlxoFcdHN7AWhiKCt6Ne3jMQVrKFkZ+by6cZExOPR/DJD7g4
	 1IaqpXKeHDWiJJE+Hp5om/G8cEFeY+Bn9H2bjlTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/83] firmware: tegra: bpmp: Return directly after a failed kzalloc() in get_filename()
Date: Thu, 11 Apr 2024 11:56:46 +0200
Message-ID: <20240411095413.106971704@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 1315848f1f8a0100cb6f8a7187bc320c5d98947f ]

The kfree() function was called in one case by
the get_filename() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

Thus return directly after a call of the function “kzalloc” failed
at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/tegra/bpmp-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/tegra/bpmp-debugfs.c b/drivers/firmware/tegra/bpmp-debugfs.c
index 9d3874cdaaeef..34e4152477f3b 100644
--- a/drivers/firmware/tegra/bpmp-debugfs.c
+++ b/drivers/firmware/tegra/bpmp-debugfs.c
@@ -81,7 +81,7 @@ static const char *get_filename(struct tegra_bpmp *bpmp,
 
 	root_path_buf = kzalloc(root_path_buf_len, GFP_KERNEL);
 	if (!root_path_buf)
-		goto out;
+		return NULL;
 
 	root_path = dentry_path(bpmp->debugfs_mirror, root_path_buf,
 				root_path_buf_len);
-- 
2.43.0



