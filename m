Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CF5178384;
	Tue,  8 Oct 2024 12:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390880; cv=none; b=Dpc3x81DHxRFBT5pGBuJ8uzLg0UbS7nSo/aLpIciuI5TUmNx2W2puT1uL215+E8qquh0oAOKr7u31+7ZEsZJ1M+ZUKJ6H8/t0ZCYC84iEjcfxF25vef8fsqlxNdm5vTEhAUwKBUtSCQJp1C98j4AZ4VCeumL1A5IDTnpt+rUXuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390880; c=relaxed/simple;
	bh=gXRf/nT+YPsKOobSx9H4pOSDyh60UFiI41HMgxiFPwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fh9/llgg7qRq+ja61TwUfXMAbry4x0kucawPmQnkurIlT6HhISwwKEYUyXQ/jtXmsYTykOpXVwooq2QSmiGNaOe/mOKJmHESZ00vjhxbrAbCBJgAHx2FTSzYI7w4Vx8x68qJitBIOhcgaaabbUDsJooznSLLZUNfUl6yj1+pUgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdIYp0qA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdIYp0qA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E460EC4CEC7;
	Tue,  8 Oct 2024 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390880;
	bh=gXRf/nT+YPsKOobSx9H4pOSDyh60UFiI41HMgxiFPwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdIYp0qA+ree6OIeIfO6K4kvUuhwvknFQ4wFE3x/bdQYsyq6xA68V4eyzSTf6xF+E
	 RYkSewCoiafxWkDnkfYyrUVH8Kopu6uFOp0NfCf75K872giikyQjoWFtNsWW/2S9ov
	 jFlkJamC8Bwm13q3xxdsRaS84HTOhl59CyK1VyJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mikisabate@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 421/482] cpufreq: Avoid a bad reference count on CPU node
Date: Tue,  8 Oct 2024 14:08:04 +0200
Message-ID: <20241008115704.972840351@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mikisabate@gmail.com>

commit c0f02536fffbbec71aced36d52a765f8c4493dc2 upstream.

In the parse_perf_domain function, if the call to
of_parse_phandle_with_args returns an error, then the reference to the
CPU device node that was acquired at the start of the function would not
be properly decremented.

Address this by declaring the variable with the __free(device_node)
cleanup attribute.

Signed-off-by: Miquel Sabaté Solà <mikisabate@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/20240917134246.584026-1-mikisabate@gmail.com
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpufreq.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1113,10 +1113,9 @@ static inline int parse_perf_domain(int
 				    const char *cell_name,
 				    struct of_phandle_args *args)
 {
-	struct device_node *cpu_np;
 	int ret;
 
-	cpu_np = of_cpu_device_node_get(cpu);
+	struct device_node *cpu_np __free(device_node) = of_cpu_device_node_get(cpu);
 	if (!cpu_np)
 		return -ENODEV;
 
@@ -1124,9 +1123,6 @@ static inline int parse_perf_domain(int
 					 args);
 	if (ret < 0)
 		return ret;
-
-	of_node_put(cpu_np);
-
 	return 0;
 }
 


