Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B437FF60;
	Sat, 12 Sep 2026 11:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213803; cv=none; b=uZ7vGBTmI5YitAdoy39MdV7/wJP4HuD3oy/ZptVTgIT/XrL9rCqbCypZlE3dV/AmN0rxfUPt0wt905hUn793UB91bI/vCGs69zQtOAL+t1ATUNSyyaqpP10nwxAkFIMXpmVB0+f0MZMs74FN0VXCdxjHzlFtxv5JiAUJpPEWuC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213803; c=relaxed/simple;
	bh=0e0p+ZKCJkhTLjNEgaBWUOdnY7+G030UyjnxLfMI2eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvZN8H5js7q5ZZnslb38sNJCxVvdc2/8LnBP2ymv+DJm3Mk+lim8pW5W0qFMJTq6Uu6dFFNn2dpiauIFPE93rrEz5JqxhDg9AFM5+rWFkoUO4bQmBRRcg1H19DBmecudCase//r+PZwvE28DIYdwZGEVnKDBSBBQu22C6PIoXio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrHOuzSB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrHOuzSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C621F000FF;
	Sat, 12 Sep 2026 11:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213802;
	bh=KHkMswPHc2GgjMyYfbQj4KsLngD+f9w3kLrkt0ZPKlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrHOuzSBDNA0l4eizCLhu5fJOehs5gsnbSzjy6JiNPhs714JOHW88d2BQbvkijXti
	 ZvEXoFVIlfEK77zUN13F++jfvnBrWgxOYSdIerYpAp6JcQ7C3RYVcDh24JEOsxiTX1
	 wNfzSVRS0xwEuqtI5VAh0SydljsIlCb0aI++Fl3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.12 0197/1376] media: intel/ipu6: fix async notifier cleanup leak on parse error
Date: Sat, 12 Sep 2026 08:43:43 +0200
Message-ID: <20260912065611.939811772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit abb1f808ceab5a3275f8a6b4e37cff17f9f781c1 upstream.

isys_notifier_init() calls v4l2_async_nf_init() and then adds fwnode
remote subdevs in a loop with v4l2_async_nf_add_fwnode_remote(). If an
endpoint parse or add fails partway through the loop, it jumps to
err_parse and returns without calling v4l2_async_nf_cleanup(), leaking
every v4l2_async_connection already added to the notifier's waiting
list.

The register-failure path just below already cleans up correctly, and
the caller only tears the notifier down (isys_notifier_cleanup()) once
isys_notifier_init() has returned success. Clean up the notifier on the
parse error path too.

Fixes: f50c4ca0a820 ("media: intel/ipu6: add the main input system driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/intel/ipu6/ipu6-isys.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys.c
@@ -761,6 +761,7 @@ static int isys_notifier_init(struct ipu
 
 err_parse:
 		fwnode_handle_put(ep);
+		v4l2_async_nf_cleanup(&isys->notifier);
 		return ret;
 	}
 


