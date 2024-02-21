Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADF6763FE;
	Wed, 21 Feb 2024 13:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521758; cv=none; b=mLU3u00tsE6PwbYbqTd/3GrXIw/5WIXm6RDjOJmPSR201mmXVCI61MOb9XLGq7WkRRLChBROw6+njlBNnq/r5+OCRK2iMUe54UO3nFH3eUotgkJjdbMBrL2trOUN1DoQ+cu5Co7kBWhxra7SS1sPy2E2gF3dK6F0a1GtHwevLOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521758; c=relaxed/simple;
	bh=qQcP0oFSN9RR40+te1j65J34tmqKnzD8quYbnin9y9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFhcNZphDwq/TKdexx5k2ZxH7T23z2yGEP1uDG4f3AFDm8l73wtX2zHuyHFs2SkQyTTDnKf3jQrb6cAhEV4GDzZ6weOVCKtQdQvF0em5+MF2aetfQ1OjHyEzwmOwCSa5IOtFZrxcfp0v0BrKtvLRFXHq/0umZhmhdXClM0hjzTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONwW33z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONwW33z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93401C433C7;
	Wed, 21 Feb 2024 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521758;
	bh=qQcP0oFSN9RR40+te1j65J34tmqKnzD8quYbnin9y9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONwW33z23YhMRJF5rBZ2Voq55oM+SerYOatpixk3ElMdWlpkFjwaZ/+IRSwnP9O7O
	 1UDEA8YIIrjDyssMmvdC2nfleQkBYAbYFMSSP/FC8UvGoGF17Y0c79IQ6fU2ak0VxN
	 3uuAz3ypbw8pSHm8rNaWr6SdaV2tq/A1UFCyz2qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 196/202] pmdomain: core: Move the unused cleanup to a _sync initcall
Date: Wed, 21 Feb 2024 14:08:17 +0100
Message-ID: <20240221125938.125257117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit 741ba0134fa7822fcf4e4a0a537a5c4cfd706b20 upstream.

The unused clock cleanup uses the _sync initcall to give all users at
earlier initcalls time to probe. Do the same to avoid leaving some PDs
dangling at "on" (which actually happened on qcom!).

Fixes: 2fe71dcdfd10 ("PM / domains: Add late_initcall to disable unused PM domains")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231227-topic-pmdomain_sync_cleanup-v1-1-5f36769d538b@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/power/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -847,7 +847,7 @@ static int __init genpd_power_off_unused
 
 	return 0;
 }
-late_initcall(genpd_power_off_unused);
+late_initcall_sync(genpd_power_off_unused);
 
 #if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_GENERIC_DOMAINS_OF)
 


