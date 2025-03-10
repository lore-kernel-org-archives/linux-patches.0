Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F29233703;
	Mon, 10 Mar 2025 17:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628193; cv=none; b=atp3Fk1vGpdkfzdTNyTY8dy7WSpf+rjlCNjBwKopAFTdDGQbz/9aGsuDXnf7gaJnYyijj5UblDpI3sLZW6XvgdyK2WCPnd758v3uJQ936x+SMdNrtFgwk6EawlTg3ZJjGa1s/fKdocxuZC3dgDYRIQl+m15G/G+8FXV0Jmi4a04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628193; c=relaxed/simple;
	bh=PAknLJuubFR7t3XHJI0NvyDlX3NhXvTYOXVrY89lTzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgiPF8Sie8NyrBVpI1HJ2A0YARVWuC2RQOybjQA7AvMbDlu1uQmWgTuEHNZyUUBgXDsEpKSS70wob5NRLAlMH+dYSH43vScOVcD/7WD0zam0QJtAqp6p68gMELoG5tvsIIX50OtadAAlAnkAdIQKca0VXVr1e8YDjYblB+udC/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dq9nxcJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dq9nxcJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D788BC4CEE5;
	Mon, 10 Mar 2025 17:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628193;
	bh=PAknLJuubFR7t3XHJI0NvyDlX3NhXvTYOXVrY89lTzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dq9nxcJXmJiddB9A7frNiSKtdyRRXom0AlKHCrw2SDkmIWqLaakDD4BOIh3wrmdjn
	 /SPifgleQrDaU1S3lvc/pAIlcF4977sSMVrJ0CI89B2WHeG9sE4swHFJQtx2QckNIu
	 4DS8IcXtTFOaojWldNh97IGHzpAs/zZFbr7c26IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.6 119/145] drivers: core: fix device leak in __fw_devlink_relax_cycles()
Date: Mon, 10 Mar 2025 18:06:53 +0100
Message-ID: <20250310170439.567740540@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit 78eb41f518f414378643ab022241df2a9dcd008b upstream.

Commit bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize
cycle detection logic") introduced a new struct device *con_dev and a
get_dev_from_fwnode() call to get it, but without adding a corresponding
put_device().

Closes: https://lore.kernel.org/all/20241204124826.2e055091@booty/
Fixes: bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize cycle detection logic")
Cc: stable@vger.kernel.org
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20250213-fix__fw_devlink_relax_cycles_missing_device_put-v2-1-8cd3b03e6a3f@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2026,6 +2026,7 @@ static bool __fw_devlink_relax_cycles(st
 out:
 	sup_handle->flags &= ~FWNODE_FLAG_VISITED;
 	put_device(sup_dev);
+	put_device(con_dev);
 	put_device(par_dev);
 	return ret;
 }


