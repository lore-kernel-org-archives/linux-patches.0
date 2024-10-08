Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAC61DF25B;
	Tue,  8 Oct 2024 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393981; cv=none; b=sP6SzhmgKGHkSx9fcNrzXdOIANO7WN33Lgz+SSl9fHlZpNqQAZ7VOpV0Gz37ZpZrU69ha8ovdmU4qCcOzoe1cFEqM98GffyRrJNLqxJK3AwzYZNVbjv84Guw3ztdkGnEBWnQmi9nLuCFkEKOpRDPRifbNQ10uFPdAf4O29ej+KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393981; c=relaxed/simple;
	bh=zGFYyyBUK3JjOv4plps//pgi+FEGJuTuxsWcGs863Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBMZZ24oPP1Mfec9jCB4isy32df7Uc3fpKyaLHlvlYZXLzP749gVeumqkGKbMFJ3+ThQ+7BOM8QK3fkebfFCAk4el1SOXFp3Af9J5Y39YcP19LKYvJgRqBQRDg6r+eSPyWDtVtZ67ZGraImVUO8cAfmdIN6vxv+F+VRPmLOj7IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdDVtVVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdDVtVVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F659C4CECC;
	Tue,  8 Oct 2024 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393981;
	bh=zGFYyyBUK3JjOv4plps//pgi+FEGJuTuxsWcGs863Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdDVtVVQ4ch1Yu3q/sSwOnJfyk4MALfiCmxCc0lxhetSoEw6Hu1pdPIcEy0GDqhTf
	 3ECfgiHusEKS0wYogTzU89BX+3Z79ivCGgjHTjvHqHEcE12Sqdp+OEN2x2IllFEzRg
	 lNEbmOFFIq8HLnK3zvkCdTUXGgJ0LounuX2mQpEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mikisabate@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 311/386] cpufreq: Avoid a bad reference count on CPU node
Date: Tue,  8 Oct 2024 14:09:16 +0200
Message-ID: <20241008115641.624481764@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1124,10 +1124,9 @@ static inline int parse_perf_domain(int
 				    const char *cell_name,
 				    struct of_phandle_args *args)
 {
-	struct device_node *cpu_np;
 	int ret;
 
-	cpu_np = of_cpu_device_node_get(cpu);
+	struct device_node *cpu_np __free(device_node) = of_cpu_device_node_get(cpu);
 	if (!cpu_np)
 		return -ENODEV;
 
@@ -1135,9 +1134,6 @@ static inline int parse_perf_domain(int
 					 args);
 	if (ret < 0)
 		return ret;
-
-	of_node_put(cpu_np);
-
 	return 0;
 }
 


