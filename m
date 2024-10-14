Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD561ABEBA;
	Mon, 14 Oct 2024 14:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916439; cv=none; b=UmQNXOwrK6K8JBx/rV6a1D4by4P1/SZXOUWEthqGqSjgjoHsjLXT7tTkYchkUXpyeZizDPDqEWMvynytDjzPNkgmdUOU7v0z/BmdfUNV7b0v8g8CJ7FyOzCegF5/YkMGZq2aPpt9NxL3Qdq9DBWA2GxWtAdyeHPH8/2aR8IqYNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916439; c=relaxed/simple;
	bh=R2J771YKB08MBvcLBbhDSxhbPFue6fpexCAPoxfbfgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fB5RTZNIiJ6S1jzRD3L/1s1MbzlcVqlYre/terv99lORMhqRwR4wAsPjihUY7FyUh9nK257vhiVgGO8nOl+QSzt+pD86AWxbk8JobQdUA22oewV+LE91NZHTmfZhiPdfYwkLmMZ18/7bXm0ob3/pdFs9JTc9XNHvH/J79wUwm8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Azh6C10b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Azh6C10b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EB8C4CEC3;
	Mon, 14 Oct 2024 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916438;
	bh=R2J771YKB08MBvcLBbhDSxhbPFue6fpexCAPoxfbfgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Azh6C10brU6EHncGXpffYAqBsRrPAlUt+oRM0NtMPym0/eWSzmOCcmNlbpU7D9WLn
	 9N+pmn66lp1C4WyFiHmZiCDzGh40Phi8Vv/T4RP0eew9JLjCu4DdF5fK0ceHIZu0Zd
	 akHLikKMHBBdfbBA41uFSif01fPFB99Jj1ntPS9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.11 183/214] thermal: core: Free tzp copy along with the thermal zone
Date: Mon, 14 Oct 2024 16:20:46 +0200
Message-ID: <20241014141052.123108521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 827a07525c099f54d3b15110408824541ec66b3c upstream.

The object pointed to by tz->tzp may still be accessed after being
freed in thermal_zone_device_unregister(), so move the freeing of it
to the point after the removal completion has been completed at which
it cannot be accessed any more.

Fixes: 3d439b1a2ad3 ("thermal/core: Alloc-copy-free the thermal zone parameters structure")
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/4623516.LvFx2qVVIh@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1647,14 +1647,12 @@ void thermal_zone_device_unregister(stru
 	ida_destroy(&tz->ida);
 
 	device_del(&tz->device);
-
-	kfree(tz->tzp);
-
 	put_device(&tz->device);
 
 	thermal_notify_tz_delete(tz);
 
 	wait_for_completion(&tz->removal);
+	kfree(tz->tzp);
 	kfree(tz);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);


