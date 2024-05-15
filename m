Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666A3A29F;
	Wed, 15 May 2024 06:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715753736; cv=none; b=bibSqVgqoAXg7g11scenR7vEj2rFGs3RticXVaaXdwAlFEiUGOE7sYsy2xhqStsqmL00VhD1bz3iYyxhBHu0ckb0m/M+6efRTzssivxfdPMzgPzkyJFhMJCZ2iZkFMqFtYcHmC8q1Q0XDgc2+ylc2ZT/9SPxZLQ1dJIcTkY4Jlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715753736; c=relaxed/simple;
	bh=QW0ePSHkW552niEBjTaVu6MQs1tT30hlRqsaoskf3Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fdNzNmIINBwnZ/7xTx51v+fTM6PU/eKmbi6bcNhiXfNAgFBcxwH7+D32vXlPOSnOo1BSq+K+rPjcO+CmAeQONoM61o3WVqks8mFMzC6lNjDXkzPOshvhuewTT+bLlVtH9foZLyVLdA0ujM0luOCVoHTj+hL5DEiaqwptp5C6bWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BWte8rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BWte8rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAB6C2BD11;
	Wed, 15 May 2024 06:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715753735;
	bh=QW0ePSHkW552niEBjTaVu6MQs1tT30hlRqsaoskf3Vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0BWte8rQZ/gV8H3Pk2iX4yEv1WsPvTennu4dSZquli4mIjgs0Uqi3q0ry2063Zkpz
	 /YUzWPtzPbqJiwxUKgN2m0O1NeKM60tLfp7jJkh8xKOrkTDBpn92Mi+uGjjn9i/NNu
	 KcvFt3pVBAmRI7Gbh09hKqEqeSquBMOVleHz2TFE=
Date: Wed, 15 May 2024 08:15:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	Russell Currey <ruscur@russell.cc>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 088/236] powerpc/pseries: Implement signed update for
 PLPKS objects
Message-ID: <2024051524-polyester-preoccupy-2236@gregkh>
References: <20240514101020.320785513@linuxfoundation.org>
 <20240514101023.710898376@linuxfoundation.org>
 <9d093600382fb412381827365a5a342d632d1269.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9d093600382fb412381827365a5a342d632d1269.camel@linux.ibm.com>

On Wed, May 15, 2024 at 10:01:06AM +1000, Andrew Donnellan wrote:
> On Tue, 2024-05-14 at 12:17 +0200, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me
> > know.
> > 
> > ------------------
> > 
> > From: Nayna Jain <nayna@linux.ibm.com>
> > 
> > [ Upstream commit 899d9b8fee66da820eadc60b2a70090eb83db761 ]
> > 
> > The Platform Keystore provides a signed update interface which can be
> > used
> > to create, replace or append to certain variables in the PKS in a
> > secure
> > fashion, with the hypervisor requiring that the update be signed
> > using the
> > Platform Key.
> > 
> > Implement an interface to the H_PKS_SIGNED_UPDATE hcall in the plpks
> > driver to allow signed updates to PKS objects.
> > 
> > (The plpks driver doesn't need to do any cryptography or otherwise
> > handle
> > the actual signed variable contents - that will be handled by
> > userspace
> > tooling.)
> > 
> > Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
> > [ajd: split patch, add timeout handling and misc cleanups]
> > Co-developed-by: Andrew Donnellan <ajd@linux.ibm.com>
> > Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> > Signed-off-by: Russell Currey <ruscur@russell.cc>
> > Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
> > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > Link:
> > https://lore.kernel.org/r/20230210080401.345462-18-ajd@linux.ibm.com
> > Stable-dep-of: 784354349d2c ("powerpc/pseries: make max polling
> > consistent for longer H_CALLs")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This is a new feature and I don't think it should be backported.
> 784354349d2c can be backported by dropping the
> plpks_signed_update_var() hunk.
> 

Now dropped and fixed up, thanks.

greg k-h
